#!/bin/bash
# write git information into plain files to reduce amount to reduce same bash scripting again and again

set -e

DIST_DIRECTORY=".build/dist"
GIT_META_DIRECTORY=".git-meta"

if [ -e $DIST_DIRECTORY ] && [ -e $GIT_META_DIRECTORY ]; then
	for path in $GIT_META_DIRECTORY/*; do
		echo "Checking meta information in $path"

		key=`basename $path`
		marker="\${git:$key}"
		value=`cat $path`
		echo "Replacing $marker with '$value' in $DIST_DIRECTORY..."
		grep -RiIl "$marker" $DIST_DIRECTORY | xargs sed -i "s/$marker/$value/g"
	done
else
	echo "Either $DIST_DIRECTORY or $GIT_META_DIRECTORY is missing"
fi