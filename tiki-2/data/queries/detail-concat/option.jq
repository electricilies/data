[.[]
  | {name: .specifications[].attributes[].name, product_id: .id}
]
| to_entries
| map({id: (.key + 1), name: .value.name, product_id: .value.product_id})
