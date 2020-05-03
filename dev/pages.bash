#!/bin/bash
set -e
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
	*) ;;
	esac
	shift
done

URL="."
IMG_HEIGHT=$(identify -format '%h' "${IMG_URL}")
IMG_WIDTH=$(identify -format '%w' "${IMG_URL}")

function ZERO_PAD(){
	printf "%0${#MAX}d" $1
}

function IMG_URL() {
	NUM=$1
	echo -n "${URL}/${NUM}.html"
}

function JUMP_TAG() {
	NAME=$1
	TO=$2
	echo -n "<a href=\"$(IMG_URL ${TO})\">${NAME}</a>"
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

function NAVI(){
	cat <<EOF
<div style="text-align:left">$(PREV)</div>
<div style="text-align:center">$(PREV)  $(ZERO_PAD ${NUM})  $(NEXT)</div>
<div style="text-align:right">$(NEXT)</div>
EOF
}

cat <<EOF
$(NAVI)
<img src="${IMG_URL}" usemap="#image" width="100%" >
$(NAVI)
$(for i in $(seq ${MAX}); do
		if [[ ${i} -eq ${NUM} ]]; then
			echo -n "***$(ZERO_PAD ${i})*** "
			continue
		fi
		echo -n "<a href=\"${URL}/${i}.html\" id=\"${i}\">$(ZERO_PAD ${i})</a> "
	done
)
EOF
