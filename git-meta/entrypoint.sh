#!/bin/bash
# write git information into plain files to reduce amount to reduce same bash scripting again and again

set -e

GIT_META_DIRECTORY=".git-meta"
mkdir -p $GIT_META_DIRECTORY

echo `git rev-parse HEAD` > $GIT_META_DIRECTORY/hash
echo `git branch | grep \* | cut -d ' ' -f2` > $GIT_META_DIRECTORY/branch

GIT_LAST_MESSAGE=$(git log -1 --pretty=oneline)
echo $GIT_LAST_MESSAGE > $GIT_META_DIRECTORY/message_short

GIT_LAST_TAG_COMMIT=`git rev-list --tags --max-count=1`

if [ $? -ne 0 ] || [ ! $GIT_LAST_TAG_COMMIT ]; then
	echo "Last commit in this branch is not a tag commit"
else 
	GIT_LAST_TAG=`git describe --tags --abbrev=0 $GIT_LAST_TAG_COMMIT`
	GIT_LAST_COMMIT=`git log --max-count=1 --pretty="%H"`

	if [ "$GIT_LAST_TAG_COMMIT" == "$GIT_LAST_COMMIT" ]; then
		echo "This is a tag commit with tag $GIT_LAST_TAG"
		echo $GIT_LAST_TAG > $GIT_META_DIRECTORY/tag
	fi
fi
