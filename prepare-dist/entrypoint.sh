#!/bin/bash
# write git information into plain files to reduce amount to reduce same bash scripting again and again

set -e

DIST_DIRECTORY=".build/dist"
mkdir -p $DIST_DIRECTORY

rsync -av \
	--exclude ".build" \
	--exclude ".git-meta" \
	--exclude ".git" \
	--exclude "test" \
	--exclude-from='.exclude' \
	. \
	$DIST_DIRECTORY
