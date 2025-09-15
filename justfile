[private]
mkdir path:
  mkdir -p {{path}}

[unix]
chotot pages="100" path="./chotot/data":
  just mkdir {{path}}
  seq 1 {{pages}} | parallel ./chotot/script.sh {} {{path}}

[unix]
tiki pages="50" path="./tiki/data":
  for page in {1..{{pages}}}; do
    ./tiki/crawl.sh "$page" "$path"
  done
