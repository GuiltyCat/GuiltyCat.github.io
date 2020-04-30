#!/bin/bash
LEFT=$1
RIGHT=$2
cat <<EOF
<div id="left">
<iframe src="${LEFT}" name="left">
</iframe>
</div>
<iframe src="${RIGHT}" name="right">
# </iframe>
EOF
# <div id="right">
# </div>
