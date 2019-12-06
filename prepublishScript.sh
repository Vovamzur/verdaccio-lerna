#!/usr/bin/env bash

# This script is used to change "unrealesed" sections in CHNAGELOG to current version and current date in prepublishOnly script
#
# add  to root package.json 
# {
#     ...
#     "scripts" : {
#         ...
#         "prepublishOnly": "./tools/prepublishScript.sh"
#     }
# }
#
# example:
#   ## [Unreleased]  =>  ## [1.17.0] - 2019-12-02


echo '--------------------- Check all CHANGELOG ---------------------' &&

refreshLogs() {
    if grep -q 'Unreleased' "$1"; then
        path=`dirname $1`
        while read line; do
            if [[ $line =~ \[Unreleased\]$ ]]; then
                local current_date=`date '+%Y-%m-%d'`
                current_version=`node -p "require('$path/package.json').version"`
                local version_string="\[$current_version\]"
                local line_with_date="## ${version_string} - ${current_date}"
                line_with_date="## [Unreleased]\n\n${line_with_date}"
                line=${line/\[/\\[}
                line=${line/\]/\\]}
                sed -i "s/^.*$line.*$/$line_with_date/g" $1 &&
                git add $1
            fi
        done < $1
    fi
}

packagesDirectories=`node -p "require('./lerna.json').packages"`
packagesDirectories=`echo $packagesDirectories | sed "s/[]['',]//g"`
for packagePath in $packagesDirectories
do
    for path in `find $(pwd)/$packagePath -type f -path */CHANGELOG.md` 
    do
        refreshLogs $path
        echo -e " \033[0;36m$path\033[0m"
    done 
done
if [[ ! -z `git diff --exit-code` ]]; then
    git commit -m "add dates of versions' releases at changelogs before publish"
fi
