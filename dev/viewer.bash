#!/bin/bash
LEFT=$1
RIGHT=$2
cat <<EOF
<div id="left">
<iframe src="${LEFT}" name="left">
あいうえお
</iframe>
</div>
<div id="right">
<iframe src="${RIGHT}" name="right">
asdfasdfasdf
</iframe>
</div>
EOF
# <div id="right">
# </div>
