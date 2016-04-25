#!/bin/bash
set -e

[ ! $1 ] && echo "please specify a tar.gz file" && exit 1

TAR_GZ_FILE=$1

SCRIPT_DIR=${0%/*}
cd $SCRIPT_DIR/..
VERSION=$(git rev-parse HEAD)
WD=$(pwd)

echo "Registering URLs with heroku..."
URL_OUTPUT=$(curl -n -X POST https://api.heroku.com/apps/mario-test/sources \
-H 'Accept: application/vnd.heroku+json; version=3') 

GET_URL=$(echo $(echo $URL_OUTPUT | scripts/JSON.sh -l | grep get_url | cut -d$'\t' -f2 | tr '"' ' '))
PUT_URL=$(echo $(echo $URL_OUTPUT | scripts/JSON.sh -l | grep put_url | cut -d$'\t' -f2 | tr '"' ' '))

echo "get_url $GET_URL"

echo "Uploading $TAR_GZ_FILE to heroku..."
curl "$PUT_URL" \
  -X PUT -H 'Content-Type:' --data-binary @$TAR_GZ_FILE



echo "Telling heroku to go deploy..."
curl -n -X POST https://api.heroku.com/apps/mario-test/builds \
-d "{\"source_blob\":{\"url\":\"$GET_URL\", \"version\": \"$VERSION\"}}" \
-H 'Accept: application/vnd.heroku+json; version=3' \
-H "Content-Type: application/json"
echo 
echo "Successfully deployed tar.gz to Heroku"
