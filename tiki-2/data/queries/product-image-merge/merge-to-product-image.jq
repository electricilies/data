def int_to_uuid($n):
  $n | tostring | (32 - length) * "0" + .
  | .[0:8] + "-" + .[8:12] + "-7" + .[13:16] + "-" + .[16:20] + "-" + .[20:32]
;

group_by(.product_id)
| map(to_entries | map(.value + {order: (.key + 1)})) 
| flatten 
| to_entries 
| map(.value + {id: (.key + 1)})
| .[]
| [int_to_uuid(.id),
    .url,
    .order,
    int_to_uuid(.product_id),
    if .product_variant_id != null then int_to_uuid(.product_variant_id) else null end
  ]
| @csv
