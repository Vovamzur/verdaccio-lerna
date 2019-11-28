#!/usr/bin/env bash

echo '--------------------- Check all CHANGELOG ---------------------' &&

refreshLogs() {
    cat $1 | while read line 
    do
        [[ $line =~ \[Unreleased\]$ ]] &&
        current_date=`date '+%Y-%m-%d'` &&
        version_string=`npm version patch | cut -c 2-` &&
        version_string="[$version_string]"
        line_with_date="## ${version_string} - ${current_date}" &&
        line=${line/\[/\\[} &&
        line=${line/\]/\\]} &&
        sed -i "s/^.*$line.*$/$line_with_date/g" $1
    done
}

repositoryFolder=`git rev-parse --show-toplevel` &&
find $(pwd)/ -type f -path \*/CHANGELOG.md | grep -v node_modules | sort | uniq | while read path 
do
    echo -e " \033[0;36m$path\033[0m" &&
    refreshLogs $path
done
# git add \*/CHANGELOG.md &&
# git commit -m "add dates of versions' releases at changelogs" &&
# git push
