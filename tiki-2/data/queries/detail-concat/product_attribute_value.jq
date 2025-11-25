def int_to_uuid($n):
  $n | tostring | (32 - length) * "0" + .
  | .[0:8] + "-" + .[8:12] + "-7" + .[13:16] + "-" + .[16:20] + "-" + .[20:32]
;

[
  .[] as $p
  | $p.specifications[].attributes[]
  | . + { product_id: $p.id }
] as $all_attrs

| ($all_attrs
  | unique_by(.code)
) as $mapping

| ($all_attrs | unique_by({code, value})) as $unique_values

| range(0; ($unique_values | length)) as $i
  | $unique_values[$i] as $a
  | ($mapping[] | select(.code == $a.code)) as $m
  | [
      int_to_uuid($i + 1),
      int_to_uuid($a.product_id)
    ]
  | @csv
