def int_to_uuid($n):
  $n | tostring | (32 - length) * "0" + .
  | .[0:8] + "-" + .[8:12] + "-7" + .[13:16] + "-" + .[16:20] + "-" + .[20:32]
;

[.[]
  | select(.configurable_options != null)
  | {name: .configurable_options[].name, product_id: int_to_uuid(.id)}
]
| to_entries
| map({id: int_to_uuid(.key + 1), name: .value.name, product_id: .value.product_id})
| .[]
| [.id, .name, .product_id]
| @csv
