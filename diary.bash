#!/bin/bash

function diary_list() {
	COUNTER=0
	for FILE in $(find ./md -type f | sort -n); do
		echo "${COUNTER}:${FILE}:$(head -n1 ${FILE})"
		COUNTER=$((COUNTER+1))
	done
}

while [[ $# -ne 0 ]]; do

	case $1 in
	--list | -l)
		diary_list
		exit
		;;
	--write | -w)
		shift
		NUM=$1
		FILE="$(find ./md -type f | sort -n | tail -n+$((NUM+1)) | head -n 1)"
		nvim "${FILE}"
		exit
		;;
	*) ;;
	esac
	shift
done

TODAY=$(date +%Y-%m-%d)

nvim "./md/${TODAY}.md"
