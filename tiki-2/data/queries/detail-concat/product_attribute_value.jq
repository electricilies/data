[
  .[] as $p
  | $p.specifications[].attributes[]
  | . + { product_id: $p.id }
] as $flat_attrs

| ($flat_attrs
  | unique_by(.code)
) as $mapping

| [range(0; ($flat_attrs | length)) as $i
    | $flat_attrs[$i] as $a
    | ($mapping[] | select(.code == $a.code)) as $m
    | {
        product_id: $a.product_id,
        attribute_id: ($i + 1),
      }
  ]

| .[]
| [.product_id, .attribute_id]
| @csv
