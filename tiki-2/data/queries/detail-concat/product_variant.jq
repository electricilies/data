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
| [.id, .sku, .price, .quantity, .purchase_count, .product_id]
| @csv
