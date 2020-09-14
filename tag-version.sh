#!/bin/bash
# tag-version.sh
# Usage: tag-version.sh [-h] [-d] -v VERSION -t TAG
#        -d Dry-run does not push or pull but commit to the git repo
#        -h Help text
#        -t Tag
#        -v Version
# Tags the given version

display_usage() {
}

DRYRUN='0'
HELPTEXT='0'
VERSION='none'
TAG='none'

while getopts 'dhv:t:' flag; do
    case "${flag}" in
        d) DRYRUN='1' ;;
        h) HELPTEXT='1' ;;
        v) VERSION="${OPTARG}" ;;
        t) TAG="${OPTARG}" ;;
    esac
done

if [ "$VERSION" = 'none' ]
then
    HELPTEXT='1'
fi

if [ "$TAG" = "none" ]
then
    HELPTEXT='1'
fi

readonly DRYRUN
readonly HELPTEXT
readonly VERSION
readonly TAG

BRANCH="vers``ions/$VERSION"

if [ "$HELPTEXT" -eq '1' ]
then
    echo "This script tags a specific version"
    echo "Usage: $0 VERSION TAG"
    echo "Version must be one of the versions listed in pyenv install --list"
    echo "Tag should be one of development staging production cipipeline"
    exit 1
fi

branch="versions/$VERSION"

set -e
echo "Pulling repository"
git pull
git fetch --tags
branchcount=$(git branch | grep -E "^\s*$branch\s*$" | wc -l)
tagcount=$(git tag | grep -E "^\s*$TAG\s*$" | wc -l)

if [ $branchcount -eq '0' ]
then
    echo "Version does not exist yet."
    exit 1
fi

echo "Switching to branch $BRANCH"
git switch $BRANCH

echo "Adding tag to HEAD"
git tag $TAG -f

if [ "$DRYRUN" -eq '0' ]
then
    echo "Pushing"
    git push origin --tags
else
    echo "Dry-run: Skipping git push origin --tags"
fi

git switch master
