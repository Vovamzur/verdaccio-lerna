#!/usr/bin/env bash

# refresh all CHNAGELOG files for some repository adding release dates

refreshLogs() {
    git blame $1 | while read line 
    do
        [[ $line =~ \[[0-9.a-z-]*\]$ ]] &&
        commit=`echo $line | awk '{print $1;}'` &&
        commit_date=`git show -s --format=%cd --date=short "$commit"` &&
        version_string=`echo $line | awk 'NF > 1{print $NF}'` &&
        line_with_date="## ${version_string} - ${commit_date}" &&
        version_string=${version_string/\[/\\[} &&
        version_string=${version_string/\]/\\]} &&
        version_string=${version_string//./\\.} &&
        sed -i "s/^.*$version_string.*$/$line_with_date/g" $1
    done
}

repositoryFolder=`git rev-parse --show-toplevel` &&
repository="ubjs"
rm -rf ./$repository &&
git clone https://git-pub.intecracy.com/unitybase/$repository.git &&
cd $repository &&
find $(pwd)/ -type f -path \*/CHANGELOG.md | sort | uniq | while read path 
do
    echo -e " \033[0;36m$path\033[0m"
    refreshLogs $path
done
git add . &&
git commit -m "add dates of versions' releases at changelogs" &&
echo -e "\n \033[1;36mGit status\033[1;33m" &&
git status 
# &&
# git push --set-upstream origin update-changelogs
