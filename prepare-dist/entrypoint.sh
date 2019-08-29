#!/bin/bash
# write git information into plain files to reduce amount to reduce same bash scripting again and again

set -e

DIST_DIRECTORY=".build/dist"
mkdir -p $DIST_DIRECTORY
DEFAULT_EXCLUDE_FROM=".exclude"
OPT_EXCLUDE_FROM=""

if [ -e $DEFAULT_EXCLUDE_FROM ]; then
	OPT_EXCLUDE_FROM="--exclude-from '$DEFAULT_EXCLUDE_FROM'"
fi

rsync -av \
	--exclude ".build" \
	--exclude ".git-meta" \
	--exclude ".git" \
	--exclude "test" \
	$OPT_EXCLUDE_FROM \
	. \
	$DIST_DIRECTORY
