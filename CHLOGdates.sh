#!/usr/bin/env bash

# This script update release dates in all CHNAGELOG files

refreshLogs() {
    git blame $1 | while read line 
    do
        if [[ $line =~ \[[0-9.a-z-]*\]$ ]]; then
            commit=`echo $line | awk '{print $1;}'`
            commit_date=`git show -s --format=%cd --date=short "$commit"`
            version_string=`echo $line | awk 'NF > 1{print $NF}'`
            line_with_date="## ${version_string} - ${commit_date}"
            version_string=${version_string/\[/\\[}
            version_string=${version_string/\]/\\]}
            version_string=${version_string//./\\.}
            sed -i "s/^.*$version_string.*$/$line_with_date/g" $1 &&
            git add $1
        fi
    done
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
if [[ -z `git diff --exit-code` ]]; then
    git commit -m "add dates of versions' releases at changelogs"
fi
