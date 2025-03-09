MD_FILE=$(shell ls md/*)
HTML_FILE=$(subst md,html,$(MD_FILE))
SHELL=/bin/bash
CSS=style.css

all:$(HTML_FILE) index.html Makefile sitemap.xml

html/%.html : md/%.md Makefile
	bash generate.bash --md $< --css $(CSS) >$@

index.html: index.bash $(MD_FILE) Makefile
	bash generate.bash --md <(bash $<) --css $(CSS) >$@

sitemap.xml: sitemap.bash $(HTML_FILE)
	bash $< >$@

hist:
	rm html/0000-00-00.html
	make

index:
	rm index.html
	make

clean:
	rm -rf html/*
	rm -rf index.html
