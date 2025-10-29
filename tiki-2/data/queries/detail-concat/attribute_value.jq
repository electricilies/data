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
       id: ($i + 1),
       attribute_id: $m.attribute_id,
       value: $a.value
     }
  ]
