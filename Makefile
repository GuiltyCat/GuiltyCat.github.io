MD_FILE=$(shell ls md/*)
HTML_FILE=$(subst md,html,$(MD_FILE))
SHELL=/bin/bash
BANNER=banner.html

CSS=style.css

INDEX_OPTION=-s --mathjax -f markdown -t html -c $(CSS)

ARTICLE_OPTION=$(INDEX_OPTION) -B $(BANNER) -A $(BANNER)

SED_EXP='s/\([^\n-=\.,]\)\n\([^\n-=\.,]\)/\1\2/g'

all:$(HTML_FILE) index.html html/history.html $(CSS) Makefile

md/%.md:Makefile $(CSS)


html/%.html : md/%.md
	pandoc $(ARTICLE_OPTION) --metadata title=$(shell head -n1 $<) -o $@ <(tail -n+3 $< | sed  -z $(SED_EXP))


index.html : $(CSS)


index.html: index.bash
	pandoc $(INDEX_OPTION) --metadata title=$(shell grep -B1 "^====" $< | head -n1) -o $@ <(bash $< | tail -n+3 | sed -z $(SED_EXP))

html/history.html : $(CSS)

hist:
	rm html/history.html
	make

index:
	rm index.html
	make

clean:
	rm html/*
	rm index.html
