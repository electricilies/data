def int_to_uuid($n):
  $n | tostring | (32 - length) * "0" + .
  | .[0:8] + "-" + .[8:12] + "-7" + .[13:16] + "-" + .[16:20] + "-" + .[20:32]
;

[
  .[].specifications.[].attributes
]
| add as $all_attrs

| ($all_attrs
  | unique_by(.code)
  | to_entries
  | map({attribute_id: (.key + 1), code: .value.code, name: .value.name})
) as $mapping

| ($all_attrs | unique_by({code, value})) as $unique_values

| range(0; ($unique_values | length)) as $i
  | $unique_values[$i] as $a
  | ($mapping[] | select(.code == $a.code)) as $m
  | [
      int_to_uuid($i + 1),
      int_to_uuid($m.attribute_id),
      $a.value
    ]
  | @csv
