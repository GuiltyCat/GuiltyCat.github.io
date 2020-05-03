MD_FILE=$(shell ls md/*)
HTML_FILE=$(subst md,html,$(MD_FILE))
SHELL=/bin/bash
BANNER=banner.html

CSS=style.css

INDEX_OPTION=-s --mathjax -f markdown -t html 
# -c $(CSS)

ARTICLE_OPTION=$(INDEX_OPTION) -B $(BANNER) -A $(BANNER)

all:$(HTML_FILE) index.html Makefile sitemap.xml

html/%.html : md/%.md Makefile
	pandoc $(ARTICLE_OPTION) --metadata title="$(shell head -n1 $<)" -o $@ <(./remove_newline.bash -f $< | tail -n+3)

index.html: index.bash $(wildcard md/*.md) Makefile
	pandoc $(INDEX_OPTION) --metadata title="$(shell grep -B1 "^====" $< | head -n1)" -o $@ <(bash $< |  tail -n+3 | ./remove_newline.bash)

sitemap.xml: sitemap.bash index.html $(wildcard html/*.html)
	bash $< >$@

hist:
	rm html/0000-00-00.html
	make

index:
	rm index.html
	make

clean:
	rm html/*
	rm index.html
