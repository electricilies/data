def int_to_uuid($n):
  $n | tostring | (32 - length) * "0" + .
  | .[0:8] + "-" + .[8:12] + "-7" + .[13:16] + "-" + .[16:20] + "-" + .[20:32]
;

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
| [int_to_uuid(.product_id), int_to_uuid(.attribute_id)]
| @csv
