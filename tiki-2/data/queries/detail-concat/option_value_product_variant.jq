def int_to_uuid($n):
  $n | tostring | (32 - length) * "0" + .
  | .[0:8] + "-" + .[8:12] + "-7" + .[13:16] + "-" + .[16:20] + "-" + .[20:32]
;

(
  [.[]
    | select(.configurable_options != null)
    | {product_id: int_to_uuid(.id), code: .configurable_options[].code}
  ]
  | to_entries
  | map({option_id: int_to_uuid(.key + 1), code: .value.code, product_id: .value.product_id})
) as $opts
|
(
  [.[]
    as $root
    | $opts[]
    | . as $opt
    | select(int_to_uuid($root.id) == $opt.product_id)
    | $root.configurable_options[]
    | select(.code == $opt.code)
    | .values[]
    | {
        product_id: int_to_uuid($root.id),
        value: .label,
        option_id: $opt.option_id
      }
  ]
  | to_entries
  | map({
      option_value_id: int_to_uuid(.key + 1),
      product_id: .value.product_id,
      value: .value.value,
      option_id: .value.option_id
    })
) as $opt_values
|
.[]
| select(.type == "configurable") as $root
| $root.configurable_products[] as $sub_product
| $opt_values[] as $opt_value
| select(
    int_to_uuid($root.id) == $opt_value.product_id
    and ( $sub_product.option_1 == $opt_value.value
          or ( $sub_product.option_2 == null 
               or $sub_product.option_2 == $opt_value.value
          )
    )
  )
| {
    product_variant_id: int_to_uuid($sub_product.id),
    option_value_id: $opt_value.option_value_id
  }
| [.product_variant_id, .option_value_id]
| @csv
