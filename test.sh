#!/bin/sh

branch=$1

if [[ "$branch" =~ ^v([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)-(alpha|beta|release) ]]; then
#if [[ "$branch" =~ a ]]; then
    major=${BASH_REMATCH[1]}
    minor=${BASH_REMATCH[2]}
    patch=${BASH_REMATCH[3]}
    ver_type=${BASH_REMATCH[4]}
    
    echo "Major: $major"
    echo "Minor: $minor"
    echo "Patch: $patch"
    echo "Type: $ver_type"
else
    echo "Invalid URL"
fi
