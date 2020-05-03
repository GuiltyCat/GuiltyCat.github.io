#!/bin/bash
NUM=$1
MAX=$2
URL=$3

function JUMP_TAG(){
	NAME=$1
	TO=$2
	echo "<a href=\"${URL}#${TO}\" target=\"_top\">${NAME}</a>"
}

function NEXT(){
	if [[ "${NUM}" -ne "${MAX}" ]]; then
		JUMP_TAG "&lt;" "$((NUM+1))"
	fi
}

function PREV(){
	if [[ "${NUM}" -ne 1 ]]; then
		JUMP_TAG "&gt;" "$((NUM-1))"
	fi
}

cat <<EOF
Page $1
EOF
NEXT
PREV
