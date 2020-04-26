MD_FILE=$(shell ls md/*)
HTML_FILE=$(subst md,html,$(MD_FILE))
SHELL=/bin/bash
BANNER=banner.html

CSS=style.css

SED_EXP='s/\([^\n-=\.,]\)\n\([^\n-=\.,]\)/\1\2/g'

all:$(HTML_FILE) index.html $(CSS) Makefile

md/%.md:Makefile $(CSS)


html/%.html : md/%.md
	pandoc -s -B $(BANNER) -A $(BANNER) --metadata title=$(shell head -n1 $<) -c ./$(CSS) -f markdown -t html -o $@ <(tail -n+3 $< | sed  -z $(SED_EXP))

index.html : $(CSS)

index.html: index.bash
	pandoc -s --metadata title=$(shell grep -B1 "^====" $< | head -n1) -c ./$(CSS) -f markdown -t html -o $@ <(bash $< | tail -n+3 | sed -z $(SED_EXP))

clean:
	rm html/*
	rm index.html
