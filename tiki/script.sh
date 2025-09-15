#!/usr/bin/env bash

set -euo pipefail

page=$1
path=$2
search_dir="${path}/search"
detail_dir="${path}/product-detail"
review_dir="${path}/product-review"
mkdir -p "$search_dir"
mkdir -p "$detail_dir"
mkdir -p "$review_dir"
host='https://tiki.vn/api/v2'
url="${host}/products?limit=40&q=do+dien+tu?page="
search_path="${search_dir}/search/products-page-${page}.json"
curl "${url}${page}" | jq . >"$search_path"
product_ids=$(jq -r '.data.[].id' "$search_path")
echo "$product_ids" | parallel "curl '${host}/products/{}' | jq . >${detail_dir}/product-{}-detail.json"
echo "$product_ids" | parallel "curl '${host}/reviews?limit=20&include=comments,contribute_info,attribute_vote_summary&product_id={}' | jq . >${path}/product-{}-review.json"
