#!/bin/bash

FILE=$1

cat "$1"  | \
 sed -z 's/\([^\n]\+\)\n[=]\+\n/<h1>\1<\/h1>\n/g'  | \
 sed -z 's/\$\([^\$]\+\$\)/<span class="math inline">\\(\1\\)<\/span>/g'
#cat "$1" | tr '\n' '\0' | sed -e 's/\([^\x0]\+\)[=]\+\x0/<h1>\0<\/h1>/g' | tr '\0' '\n'
# 's/\([^\x0]\+\)\x0[=]\+\x0/<h1>\0<\/h1>/g' | tr '\0' '\n'
