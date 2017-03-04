SOURCE_URL=http://www.forth200x.org/documents/html/index.html

ICON_DIR=build/forth.docset
CONTENTS_DIR=$(ICON_DIR)/Contents
RESOURCES_DIR=$(CONTENTS_DIR)/Resources
HTML_DIR=$(RESOURCES_DIR)/Documents

all: $(HTML_DIR)/www.forth200x.org $(ICON_DIR)/icon.png $(CONTENTS_DIR)/Info.plist \
     $(RESOURCES_DIR)/docSet.dsidx

$(HTML_DIR)/www.forth200x.org:
	[ -d `dirname $@` ] || mkdir -p $@
	cd `dirname $@` && wget -nv -r $(SOURCE_URL)

$(CONTENTS_DIR)/Info.plist: Info.plist
	[ -d `dirname $@` ] || mkdir -p `dirname $@`
	cp $< $@

$(ICON_DIR)/icon.png: icon.png
	[ -d `dirname $@` ] || mkdir -p `dirname $@`
	cp $< $@

$(RESOURCES_DIR)/docSet.dsidx: schema.sql mkidx.awk $(HTML_DIR)/www.forth200x.org
	[ -d `dirname $@` ] || mkdir -p `dirname $@`
	find $(HTML_DIR) -type f -name '*.html' -exec awk -f mkidx.awk {} \+ | \
	    cat schema.sql - | sqlite3 $@

dist: all
	tar -czf Forth.tgz -C build forth.docset

clean:
	rm -rf build Forth.tgz *~
