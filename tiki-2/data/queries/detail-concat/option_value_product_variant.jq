def int_to_uuid($n):
  $n | tostring | (32 - length) * "0" + .
  | .[0:8] + "-" + .[8:12] + "-7" + .[13:16] + "-" + .[16:20] + "-" + .[20:32]
;

(
  [.[]
    | select(.configurable_options != null)
    | {product_id: .id, code: .configurable_options[].code}
  ]
  | to_entries
  | map({option_id: .key + 1, code: .value.code, product_id: .value.product_id})
) as $opts
|
(
  [.[]
    as $root
    | $opts[]
    | . as $opt
    | select($root.id == $opt.product_id)
    | $root.configurable_options[]
    | select(.code == $opt.code)
    | .values[]
    | {
        product_id: $root.id,
        value: .label,
        option_id: $opt.option_id,
        code: $opt.code
      }
  ]
  | to_entries
  | map({
      option_value_id: .key + 1,
      product_id: .value.product_id,
      value: .value.value,
      option_id: .value.option_id,
      code: .value.code
    })
) as $opt_values
|
.[]
| select(.type == "configurable") as $root
| $root.configurable_products[] as $sub_product
| $opt_values[] as $opt_value
| select(
    $root.id == $opt_value.product_id
    and (
      ($opt_value.code == "option1" and $sub_product.option1 != null and $sub_product.option1 == $opt_value.value)
      or ($opt_value.code == "option2" and $sub_product.option2 != null and $sub_product.option2 == $opt_value.value)
    )
  )
| {
    product_variant_id: $sub_product.id,
    option_value_id: $opt_value.option_value_id
  }
| [int_to_uuid(.product_variant_id), int_to_uuid(.option_value_id)]
| @csv
