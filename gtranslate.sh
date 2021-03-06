#!/bin/bash

# adjust to taste
DEFAULT_TARGET_LANG=en

help="`basename $0` <text> [[<source language>] <target language>]
if target missing, use default \"$DEFAULT_TARGET_LANG\" language
if source missing, use auto"

if [[ $1 = -h || $1 = --help || $1 = "" ]]
then
    echo "$help"
    exit
fi

if [[ $3 ]]; then
    source="$2"
    target="$3"
elif [[ $2 ]]; then
    source=auto
    target="$2"
else
    source=auto
    target="$DEFAULT_TARGET_LANG"
fi

result=$(curl -s -i --user-agent "" -d "sl=$source" -d "tl=$target" --data-urlencode "text=$1" http://translate.google.com)
encoding=$(awk '/Content-Type: .* charset=/ {sub(/^.*charset=["'\'']?/,""); sub(/[ "'\''].*$/,""); print}' <<<"$result")
#iconv -f $encoding <<<"$result" | awk 'BEGIN {RS="<div"};/<span[^>]* id=["'\'']?result_box["'\'']?/ {sub(/^.*id=["'\'']?result_box["'\'']?(>| [^>]*>)([ \n\t]*<[^>]*>)*/,"");sub(/<.*$/,"");print}' | html2text -utf8
iconv -f $encoding <<<"$result" |  awk 'BEGIN {RS="</div>"};/<span[^>]* id=["'\'']?result_box["'\'']?/' | html2text -utf8
exit
