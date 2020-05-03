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
	if [[ "${NUM}" -ne "${MAX}" ]]; then
		JUMP_TAG ">" "$((NUM + 1))"
	fi
}

function PREV() {
	if [[ "${NUM}" -ne 1 ]]; then
		JUMP_TAG "<" "$((NUM - 1))"
	fi
}

cat <<EOF
<img src="${IMG_URL}" usemap="#image" width="100%" >

<dev style="text-align:center">
$(PREV)     $(NEXT) 
</dev>

$(
	for i in $(seq 100); do
		if [[ "$i" -eq "${NUM}" ]]; then
			echo -n "${i} "
			continue
		fi
		echo -n "<a href=\"${URL}/${i}.html\" id=\"${i}\">${i}</a> "
	done
)
EOF
