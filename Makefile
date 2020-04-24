MD_FILE=$(shell ls md/*)
HTML_FILE=$(subst md,html,$(MD_FILE))
SHELL=/bin/bash

all:$(HTML_FILE) index.html

html/%.html : md/%.md
	pandoc -f markdown -t html -o $@ $<

index.html: index.bash
	pandoc -f markdown -t html -o $@ <(bash $<)

clean:
	rm html/*
	rm index.html
