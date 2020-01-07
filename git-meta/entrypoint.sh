#!/bin/bash
# write git information into plain files to reduce amount to reduce same bash scripting again and again

set -e

GIT_META_DIRECTORY=".git-meta"
mkdir -p $GIT_META_DIRECTORY

## target files containing meta information
# .git-meta/hash
META_FILE_HASH=$GIT_META_DIRECTORY/hash
# .git-meta/branch
META_FILE_BRANCH=$GIT_META_DIRECTORY/branch
# .git-meta/message_short
META_FILE_MESSAGE_SHORT=$GIT_META_DIRECTORY/message_short
# .git-meta/is_tag
META_FILE_IS_TAG=$GIT_META_DIRECTORY/is_tag
# .git-meta/tag
META_FILE_TAG=$GIT_META_DIRECTORY/tag
# .git-meta/version
META_FILE_VERSION=$GIT_META_DIRECTORY/version
# .git-meta/full-version, contains "#${hash}" or "${tag} (#${hash})"
META_FILE_FULL_VERSION=$GIT_META_DIRECTORY/full_version

# extract commit hash
GIT_FILE_HASH=`git rev-parse HEAD`
printf $GIT_FILE_HASH > $META_FILE_HASH

BRANCH_INFO=`git status -b -s`

# this is only relevant if we are using GitHub Actions; otherwise ignore this
if [ ! -z "$GITHUB_REF" ]; then
	# if GITHUB_REF is used, assume we are in GH actions and we are probably in a detached state (due to actions/checkout)
	BRANCH_INFO=$GITHUB_REF
fi

# get the last part of of the branch info (e.g. "master...origin/master" for git status or "refs/heads/master") and extract the last portion
# @see https://stackoverflow.com/a/22727211
printf `echo $BRANCH_INFO | rev | cut -d'/' -f 1 | rev` > $META_FILE_BRANCH

# get the last commit message
GIT_LAST_MESSAGE=$(git log -1 --pretty=oneline)
printf $GIT_LAST_MESSAGE > $META_FILE_MESSAGE_SHORT

# identify if *this* commit is the latest commit and the latests commit has a tag assigned
GIT_LAST_TAG_COMMIT=`git rev-list --tags --max-count=1`
GIT_FULL_VERSION="#${GIT_FILE_HASH}"

# by default, we assume that we are not in a tag commit
IS_TAG_COMMIT=0

if [ $? -ne 0 ] || [ ! $GIT_LAST_TAG_COMMIT ]; then
	echo "Last commit in this branch is not a tag commit"
else 
	GIT_LAST_TAG=`git describe --tags --abbrev=0 $GIT_LAST_TAG_COMMIT`
	GIT_LAST_COMMIT=`git log --max-count=1 --pretty="%H"`

	if [ "$GIT_LAST_TAG_COMMIT" == "$GIT_LAST_COMMIT" ]; then
		IS_TAG_COMMIT=1
		
		echo "This is a tag commit with tag $GIT_LAST_TAG"
		printf $GIT_LAST_TAG > $META_FILE_TAG
		GIT_FULL_VERSION="$GIT_LAST_TAG (#${GIT_FILE_HASH})"
	fi
fi

# print the tag information
printf $IS_TAG_COMMIT > $META_FILE_IS_TAG
printf $GIT_FULL_VERSION > $META_FILE_FULL_VERSION

# prefer the tag as version information
if [ -e $META_FILE_TAG ]; then
	cp $META_FILE_TAG $META_FILE_VERSION
else
	# fall back to branch's name
	cp $META_FILE_BRANCH $META_FILE_VERSION
fi
