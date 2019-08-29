#!/bin/bash
# write git information into plain files to reduce amount to reduce same bash scripting again and again

set -e
GIT_META_DIRECTORY=".git-meta"

if [ -z "DLM_ENDPOINT" ]; then
	echo "You have to provide the \$DLM_ENDPOINT variable. Which has to point to https://your-server/wp-json/download-monitor-release-version/v1/downloads/"
	exit 1
fi

GIT_TAG_FILE="$GIT_META_DIRECTORY/tag"
if [ ! -e "$GIT_TAG_FILE" ]; then
	echo "There is no $GIT_META_DIRECTORY/tag file available. Let the meta information generate by using schakko/actions/git-meta."
	exit 1
fi

VERSION=`cat $GIT_TAG_FILE`

CREDENTIALS_BASE64=`echo "$USERNAME:$PASSWORD" | base64`

cat >release.json <<EOL
{
	"version": "$VERSION"
}
EOL

curl -v --fail --insecure -XPOST -H "Content-type: application/json" -H "Authorization: Basic $BASE64" -d "@release.json" "$DLM_ENDPOINT"
