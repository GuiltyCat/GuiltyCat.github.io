#!/bin/bash
set -e
FILE=""

FILE_NAME="False"

while [[ "$#" -ne 0 ]]; do
	case $1 in
	--max)
		shift
		MAX=$1
		;;
	--num | -n)
		shift
		NUM=$1
		;;
	--img-url)
		shift
		IMG_URL=$1
		;;
	--file_name)
		FILE_NAME="True"
		;;
	*)
		echo "Such option is not permitted."
		exit
		;;
	esac
	shift
done

function ZERO_PAD() {
	printf "%0${#MAX}d" $1
}

if [[ "$FILE_NAME" == "True" ]]; then
	echo "$(ZERO_PAD ${NUM}).html"
	exit
fi

IMG=$(identify -format "%h,%w" <(wget -q -O - "${IMG_URL}"))

IMG_HEIGHT=$(echo "${IMG}" | cut -d',' -f1)
IMG_WIDTH=$(echo "${IMG}" | cut -d',' -f2)

function PAGE_PATH() {
	NUM=$1
	echo -n "./${NUM}.html"
}

function JUMP_TAG() {
	NAME=$1
	TO=$2
	echo -n "<a href=\"$(PAGE_PATH ${TO})\">${NAME}</a>"
}

function NEXT() {
	if [[ ${NUM} -ne ${MAX} ]]; then
		JUMP_TAG ">" "$((${NUM} + 1))"
	else
		echo -n "|"
	fi
}

function PREV() {
	if [[ ${NUM} -ne 1 ]]; then
		JUMP_TAG "<" "$((${NUM} - 1))"
	else
		echo -n "|"
	fi
}

function NAVI() {
	cat <<EOF
<div style="text-align:center">
<span style="float:left">$(PREV)</span>
<span style="float:center">$(PREV)  $(ZERO_PAD ${NUM})  $(NEXT)</span>
<span style="float:right">$(NEXT)</span>
</div>
EOF
}

cat <<EOF
$(NAVI)
<img src="${IMG_URL}" usemap="#image" width="100%" >
$(NAVI)
$(
	for i in $(seq ${MAX}); do
		if [[ ${i} -eq ${NUM} ]]; then
			echo -n "***$(ZERO_PAD ${i})*** "
			continue
		fi
		echo -n "<a href=\"${URL}/${i}.html\" id=\"${i}\">$(ZERO_PAD ${i})</a> "
	done
)
EOF
