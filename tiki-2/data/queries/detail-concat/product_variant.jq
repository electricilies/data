def int_to_uuid($n):
  $n | tostring | (32 - length) * "0" + .
  | .[0:8] + "-" + .[8:12] + "-7" + .[13:16] + "-" + .[16:20] + "-" + .[20:32]
;

.[] as $original
| if $original.type == "simple" then
    [{
      id: ($original.current_seller.product_id | tonumber),
      sku: $original.sku, # Trick take the product sku as variant sku
      price: $original.price,
      quantity: $original.stock_item.max_sale_qty,
      purchase_count: 100,
      product_id: $original.id
    }]
  elif $original.type == "configurable" then
    ($original.configurable_products[] | {
      id: .id,
      sku: .sku,
      price: .price,
      quantity: $original.stock_item.max_sale_qty,
      purchase_count: 100,
      product_id: $original.id
    }) | [.]
  else
    []
  end
| add
| [int_to_uuid(.id), .sku, .price, .quantity, .purchase_count, int_to_uuid(.product_id)]
| @csv
