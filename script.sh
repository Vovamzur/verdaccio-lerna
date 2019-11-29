#!/usr/bin/env bash

[[ ! -z `git status --porcelain` ]] && echo "commit changes before publishing" && exit 1

echo '--------------------- Check all CHANGELOG ---------------------' &&

refreshLogs() {
    if grep -q 'Unreleased' "$1"; then
        path=`dirname $1` &&
        while read line; do
            [[ $line =~ \[Unreleased\]$ ]] &&
            current_date=`date '+%Y-%m-%d'` &&
            current_version=`node -p "require('$path/package.json').version"` &&
            current_version=`echo "${current_version%.*}.$((${current_version##*.}+1))"` &&
            version_string="\[$current_version\]" &&
            line_with_date="## ${version_string} - ${current_date}" &&
            line=${line/\[/\\[} &&
            line=${line/\]/\\]} &&
            sed -i "s/^.*$line.*$/$line_with_date/g" $1
        done < $1
    fi
}

repositoryFolder=`git rev-parse --show-toplevel` &&
for path in `find $(pwd)/ -type f -path \*/CHANGELOG.md | grep -v node_modules | uniq` 
do
    refreshLogs $path &&
    echo -e " \033[0;36m$path\033[0m"
done &&
for filename in `git diff --name-only`;do
    git add $filename
done &&
git status &&
[[ ! -z `git diff --exit-code` ]] && git commit -m "add dates of versions' releases at changelogs before publish"
