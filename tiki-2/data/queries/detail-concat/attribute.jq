def int_to_uuid($n):
  $n | tostring | (32 - length) * "0" + .
  | .[0:8] + "-" + .[8:12] + "-7" + .[13:16] + "-" + .[16:20] + "-" + .[20:32]
;

[.[].specifications.[].attributes] 
| add
| unique_by(.code)
| to_entries
| .[]
| [int_to_uuid(.key + 1), .value.code, .value.name]
| @csv
