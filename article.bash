#!/bin/bash

function diary_list() {
	COUNTER=0
	for FILE in $(find ./md -type f | sort -n); do
		echo "${COUNTER}:${FILE}:$(head -n1 ${FILE})"
		COUNTER=$((COUNTER + 1))
	done
}

function help() {
	cat <<EOF
$(basename $0) [--help | -h] [--list | -l] [--write | -w <NUM>]

If no option passed, today's articles opens.

--help, -h
	Print this help.

--list, -l
	Print all articles' number and title.
	For example, 

	0:md/0000-00-00.md History.
	1:md/2020-01-01.md Hello, world.
	...

	number is used for --write option.

--write, -w <NUM>
	Write article of <NUM> that appears in --list option.
EOF
}

while [[ $# -ne 0 ]]; do

	case $1 in
	--help | -h)
		help
		exit
		;;
	--list | -l)
		diary_list
		exit
		;;
	--write | -w)
		shift
		NUM=$1
		FILE="$(find ./md -type f | sort -n | tail -n+$((NUM + 1)) | head -n 1)"
		nvim "${FILE}"
		exit
		;;
	*) ;;
	esac
	shift
done

TODAY=$(date +%Y-%m-%d)

nvim "./md/${TODAY}.md"
