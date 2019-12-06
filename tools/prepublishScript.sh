#!/usr/bin/env bash

# This script is used to change "unrealesed" sections in CHNAGELOG to current version and current date in prepublishOnly script
#
# add  to root package.json 
# {
#     ...
#     "scripts" : {
#         ...
#         "version": "./tools/prepublishScript.sh"
#     }
# }     
#
# example:
#   ## [Unreleased]  =>  ## [1.17.0] - 2019-12-02


echo '--------------------- Check all CHANGELOG ---------------------' &&

unreleasedLine="## \[Ureleased\]"
unreleasedSection="$unreleasedLine\n\n"
conditionalSubstr="$unreleasedLine\n###*\n"

refreshLogs() {
    if grep -q "$conditionalSubstr" "$1"; then
        path=`dirname $1`
        local current_date=`date '+%Y-%m-%d'`
        local current_version=`node -p "require('$path/package.json').version"`
        local version_string="\[$current_version\]"
        local textToReplace="$unreleasedSection## \[${current_version}\] - ${current_date}\n"
        sed -i "s/^.*$unreleasedLine.*$/$line_with_date/g" $1 &&
        git add $1
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
