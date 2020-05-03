#!/bin/bash -e

set -e

HIST_FILE_NAME="md/0000-00-00.md"

H_TITLE=$(head -n 3 "${HIST_FILE_NAME}")
H_BODY=$(tail -n +4 "${HIST_FILE_NAME}" | tac)

git add --all
# マークダウンの日付けを見てアップデートを見てもよいが
# 実際にインターネットで公開するのはuploadしてからなので，
# インターネットへのアップロードに合わせることとする．
DATE=$(date +%Y-%m-%dT%H:%M:%S)
for NAME in $(git diff --name-only master | grep "md/" | grep -v "0000-00-00" |  tac); do
	BASE=$(basename ${NAME%.*})
	H_BODY=$(echo -e "${H_BODY}\n- ${DATE} [${BASE} $(head -n 1 ${NAME})](../html/${BASE}.html)")
done

H_BODY=$(echo "${H_BODY}" | tac)

echo -e "${H_TITLE}\n${H_BODY}" >"${HIST_FILE_NAME}"

make 
make index
git add --all

git commit -m "update"
git push origin master
