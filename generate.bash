#!/bin/bash
set -e
function RemoveNewline() {
	SED_EXP='s/\([．，]\)\n\([^\n]\)/\1\2/g'
	LC_CTYPE=UTF-8 sed -z "${SED_EXP}" $@
}

function TableOfContents() {
	FILE=$(cat -)
	TOC=$(echo "$FILE" | grep -B1 -e "^[-]\+$" | sed -e 's/^[-]\+$//' | sed -e '/^$/d' | sed -e 's/^/- /')
	head -n 3 <<<"${FILE}"
	cat <<EOF
目次 (Table of Contents)
---------------------

${TOC}
EOF
	tail -n +3 <<<"${FILE}"
}

TOP_LINK="../index.html"
TOP_NAME="トップ(TOP)"

while [[ "$#" -ne 0 ]]; do
	case $1 in
	--top-name)
		shift
		TOP_NAME=$1
		;;
	--top-link)
		shift
		TOP_LINK=$1
		;;
	--dir)
		shift
		DIR=$1
		;;
	--md)
		shift
		NAME=$1
		FILE=$(cat "$1")
		;;
	--css)
		shift
		CSS=$1
		;;
	*) ;;
	esac
	shift
done

TITLE=$(echo "$FILE" | head -n 1)
if [[ "${TITLE}" == *:*Manga* ]]; then
	COUNTER=0
	DIR_NAME="html/$(basename ${NAME%.*})"
	LINK_NAME=$(basename ${NAME%.*})
	mkdir -p "${DIR_NAME}"
	IMG_LIST=$(grep "http" <<<${FILE} | sed -e 's/[^\[]*\[.*\](\(http[^)]*\)).*/\1\n/g')
	MAX_NUM=$(echo "${IMG_LIST}" | wc -l)
	IFS='
	'
	for IMG_URL in $(echo ${IMG_LIST}); do
		COUNTER=$((COUNTER + 1))
		FILE_NAME=$(bash generate_comic.bash --file_name --max "${MAX_NUM}" --num "${COUNTER}")
		bash $0 --top-link "../$(basename ${DIR_NAME}).html" --top-name "記事(Article)" --css "${CSS}" --md <(bash generate_comic.bash --max "${MAX_NUM}" --num "${COUNTER}" --img-url "${IMG_URL}") >"${DIR_NAME}/${FILE_NAME}"
		LINK_NUM=$(printf "%0${#MAX_NUM}d" ${COUNTER})
		FILE=$(echo "${FILE}" | sed -e "s/(${IMG_URL//\//\\\/})/(${LINK_NAME//\//\\\/}\/${FILE_NAME})/")
		echo "$FILE" >&2
	done
fi

cat <<EOF
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${TITLE}</title>
<script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js" type="text/javascript"></script>
</head>
<body>
<a href="${TOP_LINK}">${TOP_NAME}</a>
$(awk -f md2html.awk <(RemoveNewline <<<${FILE} | TableOfContents))
<a href="${TOP_LINK}">${TOP_NAME}</a>
</body>
</html>
EOF
