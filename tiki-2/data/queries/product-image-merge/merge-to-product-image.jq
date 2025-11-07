group_by(.product_id)
| map(to_entries | map(.value + {order: (.key + 1)})) 
| flatten 
| to_entries 
| map(.value + {id: (.key + 1)})
| .[]
| [.id, .url, .order, .product_variant_id]
| @csv
