#!/bin/bash
ADDRESS="https://guiltycat.github.io"
function one_line(){
	FILE=$1
	echo "<url>"
	echo "<loc>${ADDRESS}/${FILE}</loc>"
	if [[ "$FILE" == "" ]]; then
		FILE="index.html"
	fi
	DATE=$(date -u +%Y-%m-%dT%H:%M:%S.%2N+09:00 -r "${FILE}")
	echo "<lastmod>${DATE}</lastmod>"
	echo "<changefreq>daily</changefreq>"
	echo "</url>"
}
cat << EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
$(one_line "")
$(one_line "index.html")
$(for FILE in html/*;do
one_line "${FILE}"
done
)
</urlset>
EOF
