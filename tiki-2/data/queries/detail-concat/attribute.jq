[.[].specifications.[].attributes] 
| add
| unique_by(.code)
| to_entries
| .[]
| [.key + 1, .value.code, .value.name]
| @csv
