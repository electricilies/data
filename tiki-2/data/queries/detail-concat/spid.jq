.[]
| select(.configurable_products | type == "array" and length > 0)
| {id, spid: .configurable_products[].id}
| "https://tiki.vn/api/v2/products/\(.id)?spid=\(.spid)"
