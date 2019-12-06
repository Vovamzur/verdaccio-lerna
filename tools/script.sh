#!/usr/bin/env bash

set -x
cd $1
changelogPath="./CHANGELOG.md"
unreleasedSection="## [Unreleased]\n"
if grep -q "## \[Unreleased\]\n###*\n" $changelogPath; then 
    while read line; do
        if [[ $line =~ \[Unreleased]\]$ ]]; then
            local current_date=`date '+%Y-%m-%d'`
            current_version=`node -p "require('./package.json').version"`
            local version_string="\[$current_version\]"
            local line_with_date="## ${version_string} - ${current_date}"   
            line_with_date="$unreleasedSection\n${line_with_date}"
            line=${line/\[/\\[}
            line=${line/\]/\\]}
            sed -i "s/^.*$line.*$/$line_with_date/g" $changelogPath &&
            git add $changelogPath
        fi
    done < $changelogPath
fi
