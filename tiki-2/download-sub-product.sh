#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC2016
just -f ./data/justfile product-spid-urls | parallel --linebuffer '
  url={}
  id=$(echo "$url" | grep -oP "products/\K[0-9]+")
  spid=$(echo "$url" | grep -oP "spid=\K[0-9]+")
  outfile="./data/sub-product/product-${id}-sub-${spid}.json"
  if [ -f "$outfile" ]; then
    echo "Exists $outfile"
    exit 0
  fi
  if curl -s "$url" | jq -M >"$outfile"; then
    echo "Done $outfile"
  else
    echo "Fail $outfile"
    rm -f "$outfile"
  fi
'
