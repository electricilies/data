def int_to_uuid($n):
  $n | tostring | (32 - length) * "0" + .
  | .[0:8] + "-" + .[8:12] + "-7" + .[13:16] + "-" + .[16:20] + "-" + .[20:32]
;

.[]
| {
    id: int_to_uuid(.id),
    name,
    price: 0,
    description,
    category_id: int_to_uuid(.breadcrumbs[1].category_id),
}
