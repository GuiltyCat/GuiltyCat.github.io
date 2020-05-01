#!/bin/bash
RIGHT=$1
cat <<EOF
<dev id="flex">
<div class="list">
<div class="inner_list">
$(for i in $(seq 100);do
echo "<a href=id=\"${i}\">List of pages.</a>"
done
)
</div>
</div>
<div>
<iframe src="${RIGHT}" name="page">
</iframe>
</div>
</div>
EOF
