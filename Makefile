MD_FILE=$(shell ls md/*)
HTML_FILE=$(subst md,html,$(MD_FILE))
SHELL=/bin/bash
BANNER=banner.html

CSS=style.css

INDEX_OPTION=-s --mathjax -f markdown -t html -c $(CSS)

ARTICLE_OPTION=$(INDEX_OPTION) -B $(BANNER) -A $(BANNER)

SED_EXP='s/\([^\n-=\.,]\)\n\([^\n-=\.,]\)/\1\2/g'

all:$(HTML_FILE) index.html $(CSS) Makefile



html/%.html : md/%.md $(CSS) Makefile
	pandoc $(ARTICLE_OPTION) --metadata title="$(shell head -n1 $<)" -o $@ <(tail -n+3 $< | sed  -z $(SED_EXP))


index.md : index.bash 
	bash $< >$@

index.html: index.md $(CSS) $(wildcard md/*.md) Makefile
	pandoc $(INDEX_OPTION) --metadata title="$(shell grep -B1 "^====" $< | head -n1)" -o $@ <(cat $< | tail -n+3 | sed -z $(SED_EXP))

hist:
	rm html/0000-00-00.html
	make

index:
	rm index.html
	make

clean:
	rm html/*
	rm index.html
