#!/bin/bash
# delete-version.sh
# Usage: delete-version.sh [-h] [-d] -v VERSION
#        -h - Help
#        -d - Dry run, does not interact with the git remote but commits
#        -v - Version
# Example: delete-version.sh -v 3.7.8
# Deletes a branch from this repository.

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
    echo "delete-version.sh"
    echo "Deletes a branch and commits it for a specific python version."
    echo "usage: delete-version.sh [-d] [-h] -v VERSION"
    echo "       -h Help text"
    echo "       -d Dry-run - does not push or pull from git repository"
    echo "       -v Version - Python version to install"
    exit 1
fi

git switch master

if [ "$DRYRUN" -eq '0' ]
then
    echo "Pulling repository"
    git pull --rebase
    git fetch
else
    echo "Dry-run: Skipping git pull --rebase && git fetch"
fi

echo "Attempting to delete branch $BRANCH for version $VERSION"
count=$(git branch -r | grep -i $BRANCH | wc -l)

if [ $count -lt '1' ]
then
    echo "Branch does not exist. Use build-version.sh first."
    exit 1
fi
echo "Deleting branch $BRANCH"
git branch -D $BRANCH


if [ "$DRYRUN" -eq '0' ]
then
    echo "Pushing deleted branch"
    git push origin --delete $BRANCH
else
    echo "Dry-run: Skipping git push origin --delete $BRANCH"
fi

git switch master
