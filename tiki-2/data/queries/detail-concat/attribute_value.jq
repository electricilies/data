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

| [range(0; ($all_attrs | length)) as $i
   | $all_attrs[$i] as $a
   | ($mapping[] | select(.code == $a.code)) as $m
   | {
       id: int_to_uuid($i + 1),
       attribute_id: int_to_uuid($m.attribute_id),
       value: $a.value
     }
  ]
