#!/usr/bin/env bash

set -euo pipefail

category_id=$1
page=$2
path=$3
search_dir="${path}/search"
detail_dir="${path}/product-detail"
review_dir="${path}/product-review"
mkdir -p "$search_dir"
mkdir -p "$detail_dir"
mkdir -p "$review_dir"
url_v2='https://tiki.vn/api/v2'
search_url="https://tiki.vn/api/personalish/v1/blocks/listings?sort=newest"
search_path="${search_dir}/category-${category_id}-page-${page}.json"
curl "${search_url}&category=${category_id}&page=${page}" | jq -M . >"$search_path"
product_ids=$(jq -M -r '.data.[].id' "$search_path")
echo "$product_ids" | parallel --halt never,fail=0 "
  if curl '${url_v2}/products/{}' | jq -M . >'${detail_dir}/product-{}-detail.json'; then
    curl '${url_v2}/reviews?limit=20&include=comments,contribute_info,attribute_vote_summary&product_id={}' | jq -M . >'${review_dir}/product-{}-review.json' || echo 'Failed review: {}' >&2
  else
    echo 'Failed detail: {}' >&2
  fi
"
