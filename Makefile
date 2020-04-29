MD_FILE=$(shell ls md/*)
HTML_FILE=$(subst md,html,$(MD_FILE))
SHELL=/bin/bash
BANNER=banner.html

CSS=style.css

INDEX_OPTION=-s --mathjax -f markdown -t html -c $(CSS)

ARTICLE_OPTION=$(INDEX_OPTION) -B $(BANNER) -A $(BANNER)

SED_EXP='s/\([^\n-=\.,]\)\n\([^\n-=\.,]\)/\1\2/g'

all:$(HTML_FILE) index.html $(CSS) Makefile sitemap.xml



html/%.html : md/%.md $(CSS) Makefile
	pandoc $(ARTICLE_OPTION) --metadata title="$(shell head -n1 $<)" -o $@ <(tail -n+3 $< | sed  -z $(SED_EXP))

index.html: index.bash $(CSS) $(wildcard md/*.md) Makefile
	pandoc $(INDEX_OPTION) --metadata title="$(shell grep -B1 "^====" $< | head -n1)" -o $@ <(bash $< | tail -n+3 | sed -z $(SED_EXP))

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
