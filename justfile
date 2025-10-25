@default:
  just --list

[private]
mkdir path:
  mkdir -p {{path}}

[unix]
chotot pages="100" path="./chotot/data":
  just mkdir {{path}}
  seq 1 {{pages}} | parallel ./chotot/script.sh {} {{path}}

[unix]
tiki pages="50" path="./tiki/data":
  #!/usr/bin/env bash
  path=${2:-./tiki/data}
  just mkdir {{path}}
  for page in {1..{{pages}}}; do
    ./tiki/script.sh "$page" "$path"
  done

[unix]
tiki-2 category_id pages="20" path="./tiki-2/data":
  #!/usr/bin/env bash

  set -euo pipefail
  just mkdir {{path}}
  for page in {1..{{pages}}}; do
    ./tiki-2/script.sh {{category_id}} "$page" {{path}}
  done
