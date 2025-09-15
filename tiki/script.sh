#!/usr/bin/env bash

page=$1
export path=$2
host='https://tiki.vn/api/v2'
url="${host}/products?limit=40&q=do+dien+tu?page="
out="${path}/products-page-${page}.json"
curl "${url}${page}" | jq . >"$out"
product_ids=$(jq -r '.data.[].id' "$out")
echo "$product_ids" | parallel "curl '${host}/products/{}' | jq . >${path}/product-detail-{}.json"
echo "$product_ids" | parallel "curl '${host}/reviews?limit=20&include=comments,contribute_info,attribute_vote_summary&product_id={}' | jq . >${path}/product-reviews-{}.json"
