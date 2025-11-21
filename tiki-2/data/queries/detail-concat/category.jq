def int_to_uuid($n):
  $n | tostring | (32 - length) * "0" + .
  | .[0:8] + "-" + .[8:12] + "-7" + .[13:16] + "-" + .[16:20] + "-" + .[20:32]
;

[
  .[].breadcrumbs.[1] 
]
| unique_by(.category_id) 
| .[] 
| [int_to_uuid(.category_id), .name]
| @csv
