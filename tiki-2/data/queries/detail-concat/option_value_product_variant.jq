(
  [.[]
    | select(.configurable_options != null)
    | {product_id: .id, code: .configurable_options[].code}
  ]
  | to_entries
  | map({option_id: (.key + 1), code: .value.code, product_id: .value.product_id})
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
        option_id: $opt.option_id
      }
  ]
  | to_entries
  | map({
      option_value_id: (.key + 1),
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
    $root.id == $opt_value.product_id
    and ( $sub_product.option_1 == $opt_value.value
          or ( $sub_product.option_2 == null 
               or $sub_product.option_2 == $opt_value.value
          )
    )
  )
| {
    product_variant_id: $sub_product.id,
    option_value_id: $opt_value.option_value_id
  }
| [.product_variant_id, .option_value_id]
| @csv
