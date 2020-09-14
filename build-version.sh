#!/bin/bash
# build-version.sh
# Usage: build-version.sh [-h] [-d] -v VERSION
#        -h Help
#        -d Dry-run - does not pull or push from git remote (but commits)
#        -v Version
# Example: build-version.sh -v 3.7.8
# Creates a buildenv docker image for python version VERSION

DRYRUN='0'
HELPTEXT='0'
VERSION='none'
while getopts 'dhv:' flag; do
    case "${flag}" in
        d) DRYRUN='1' ;;
        h) HELPTEXT='1' ;;
        v) VERSION="${OPTARG}" ;;
    esac
done

if [ "$VERSION" = 'none' ]
then
    HELPTEXT='1'
fi

readonly DRYRUN
readonly HELPTEXT
readonly VERSION

BRANCH="versions/$VERSION"

if [ "$HELPTEXT" -eq '1' ]
then
    echo "build-version.sh"
    echo "Creates a branch and commits it for a specific python version."
    echo "usage: build-version.sh [-d] [-h] -v VERSION"
    echo "       -h Help text"
    echo "       -d Dry-run - does not push or pull from git repository"
    echo "       -v Version - Python version to install"
    exit 1
fi

git switch master
if [ "$DRYRUN" -eq '0' ]
then
    echo "Pulling repository"
    git pull
    git fetch
else
    echo "Dry-run: skipped git pull && git fetch"
fi
echo "Attempting to create branch $BRANCH for version $VERSION"
count=$(git branch -r | grep -i $BRANCH | wc -l)

if [ $count -gt '0' ]
then
    echo "Branch already exists. Use delete-version.sh first."
    exit 1
fi

git switch -C $BRANCH
echo "PYTHONVERSION=$VERSION" > build.conf
git add build.conf
git commit -m "Created version $VERSION"
if [ "$DRYRUN" -eq '0' ]
then
    git push origin $BRANCH
else
    echo "Dry-run: skipped git push origin $BRANCH"
fi

echo "Done"

