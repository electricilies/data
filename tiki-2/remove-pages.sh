#!/usr/bin/env bash
set -euo pipefail

SEARCH_DIR="data/search"
DATA_DIR="data"

for json in "$SEARCH_DIR"/category-*-page-{2..20}.json; do
  echo "Processing $json..."

  # Extract IDs (integers, no quotes)
  ids=$(jq -r '.data[].id' "$json" | tr '\n' ' ')

  for id in $ids; do
    # Use globbing to delete matching files safely
    matches=($DATA_DIR/*/*${id}*)
    if [ ${#matches[@]} -gt 0 ]; then
      echo "Removing ${#matches[@]} files matching *${id}*"
      rm -f "${matches[@]}"
    fi
  done
done
