[.[]
  | {product_id: .id}
  + (.images | to_entries | map({
      order: (.key + 1), url: .value.base_url
    })[])
]
| to_entries
| map({
    id: (.key + 1),
    product_id: .value.product_id,
    order: .value.order,
    url: .value.url
  })
| .[]
| [.id, .url, .order, .product_id]
| @csv
