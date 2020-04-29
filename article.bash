#!/bin/bash

function ArticleList() {
	COUNTER=0
	for FILE in $(find ./md -type f | sort -n); do
		echo "${COUNTER}:${FILE}:$(head -n1 ${FILE})"
		COUNTER=$((COUNTER + 1))
	done
}

function Help() {
	cat <<EOF
$(basename $0) [-lw] [--help | -h] [--list | -l] [--write | -w <NUM>]

If no option passed, today's articles opens.
I only use -lw option.

--help, -h
	Print this help.

--list, -l
	Print all articles' number, file name and title list.
	For example, 

	0:md/0000-00-00.md History.
	1:md/2020-01-01.md Hello, world.
	...

	number is used for --write option.

--write, -w <NUM>
	Write article of <NUM> that appears in --list option.

--lw
	mixture of list and write.
	After listing, enter a number you want to write.
	

EOF
}

function Write(){
	NUM=$1
		FILE="$(find ./md -type f | sort -n | tail -n+$((NUM + 1)) | head -n 1)"
		nvim "${FILE}"
}

while [[ $# -ne 0 ]]; do

	case $1 in
	--help | -h)
		Help
		exit
		;;
	--list | -l)
		ArticleList
		exit
		;;
	--write | -w)
		shift
		NUM=$1
		Write ${NUM}
		exit
		;;
	-lw )
		ArticleList
		echo -n "Number to write:"
		read NUM
		Write ${NUM}
		exit
		;;
	*) ;;
	esac
	shift
done

TODAY=$(date +%Y-%m-%d)

nvim "./md/${TODAY}.md"
