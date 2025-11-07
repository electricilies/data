[
  .[].breadcrumbs.[1] 
]
| unique_by(.category_id) | .[] | [.category_id, .name] | @csv
