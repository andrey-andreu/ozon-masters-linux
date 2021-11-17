#!/bin/bash
curl -H "Accept: application/vnd.github.v3+json" 'https://api.github.com/repos/datamove/linux-git2/pulls?state=all&per_page=100' | jq "map(select(.user."login"==\"$1\"))" > /tmp/j
for (( i=2; i <= 4; i++ ))
do
curl -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/datamove/linux-git2/pulls?state=all&per_page=100&page=$i" | jq "map(select(.user."login"==\"$1\"))" >> /tmp/j
done

c=$(cat /tmp/j | jq '.[].number' | wc -l)
f=$(cat /tmp/j | jq '.[].number' | sort | head -1)
l=$(cat /tmp/j | jq "map(select(.number=="$f")) | .[].head.repo.merges_url" | wc -c)

if (( l>10 )); then
m=1
else
m=0
fi

echo "PULLS $c"
echo "EARLIEST $f"
echo "MERGED $m"

