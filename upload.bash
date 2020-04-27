#!/bin/bash -e

set -e

HIST_FILE_NAME="history.md"

git add --all
DATE=$(date +%Y-%m-%dT%H:%M:%S)
for NAME in $(git diff --name-only master | grep "md/"); do
	echo "- ${DATE} [$(basename ${NAME%.*}) $(head -n 1 ${NAME})](html/${NAME%.*}.html)" | tee -a "${HIST_FILE_NAME}"
done
make 
git add --all

git commit -m "update"
git push origin master
