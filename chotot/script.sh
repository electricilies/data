#!/usr/bin/env bash

page=$1
path=$2
url='https://www.chotot.com/mua-ban-do-dien-tu?page='
curl "${url}${page}" | htmlq -t 'script[type="application/ld+json"]' | tail -n +2 | jq '.itemListElement' >"${path}/${page}.json"
