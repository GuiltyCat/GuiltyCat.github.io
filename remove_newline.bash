#!/bin/bash

SED_EXP='s/\([．，]\)\n\([^\n]\)/\1\2/g'
if [[ "$#" -eq 0 ]]; then
	LC_CTYPE=UTF-8 sed -z "${SED_EXP}"
	exit
fi
FILE=""
while [[ "$#" -ne 0 ]]; do
	case $1 in
	--expression | -e)
		echo ${SED_EXP}
		exit
		;;
	-f)
		shift
		FILE=$1
		;;
	*) ;;

	esac
	shift
done

[[ "$FILE" == "" ]] && echo "-f <FILE_NAME>" && exit

LC_CTYPE=UTF-8 sed -z "${SED_EXP}" "${FILE}"
