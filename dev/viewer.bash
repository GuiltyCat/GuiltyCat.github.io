#!/bin/bash
RIGHT=$1
cat <<EOF
<dev id="flex">
<div class="list">
<div class="inner_list">
$(for i in $(seq 10);do
echo "<a href=\"img/${i}.html\" id=\"${i}\" target=\"image\">${i}</a>"
done
)
</div>
</div>
<div>
<iframe src="${RIGHT}" name="image">
</iframe>
</div>
</div>
EOF
# <iframe src="${RIGHT}" name="image">
