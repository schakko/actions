#!/bin/bash

set -e

GIT_LAST_TAG_COMMIT=`git rev-list --tags --max-count=1`

if [ $? -ne 0 ] || [ ! $GIT_LAST_TAG_COMMIT ]; then
	echo "No tag commit available in this branch, exiting"
	exit 0
fi

GIT_LAST_TAG=`git describe --tags --abbrev=0 $GIT_LAST_TAG_COMMIT`

if [ ! $GIT_LAST_TAG ]; then
	echo "No tags available, exiting"
	exit 0
fi

GIT_LAST_COMMIT=`git log --max-count=1 --pretty="%H"`

if [ "$GIT_LAST_TAG_COMMIT" != "$GIT_LAST_COMMIT" ]; then
	echo "Last commit $GIT_LAST_COMMIT was not tag commit ($GIT_LAST_TAG: $GIT_LAST_TAG_COMMIT)"
	exit 0
fi

GIT_LAST_MESSAGE=$(git log -1 --pretty=oneline)

echo "New tag $GIT_LAST_TAG: $GIT_LAST_MESSAGE"

# write output
echo $GIT_LAST_TAG >  .GIT_TAG
echo $GIT_LAST_COMMIT >  .GIT_LAST_COMMIT
echo $GIT_LAST_MESSAGE > .GIT_LAST_MESSAGE
