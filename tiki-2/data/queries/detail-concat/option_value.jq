(
  [.[]
    | select(.configurable_options != null)
    | {product_id: .id, code: .configurable_options[].code}
  ]
  | to_entries
  | map({option_id: (.key + 1), code: .value.code, product_id: .value.product_id})
) as $opts
|
[.[]
  as $root
  | $opts[]
  | . as $opt
  | select($root.id == $opt.product_id)
  | $root.configurable_options[]
  | select(.code == $opt.code)
  | .values[]
  | {
      value: .label,
      option_id: $opt.option_id
    }
]
| to_entries
| map({
    id: (.key + 1),
    value: .value.value,
    option_id: .value.option_id
  })
| .[]
| [.id, .value, .option_id]
| @csv
