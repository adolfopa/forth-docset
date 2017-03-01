SOURCE_URL=http://www.forth200x.org/documents/html/index.html

ICON_DIR=build/forth.docset
CONTENTS_DIR=$(ICON_DIR)/Contents
RESOURCES_DIR=$(CONTENTS_DIR)/Resources
HTML_DIR=$(RESOURCES_DIR)/Documents

all: $(HTML_DIR)/www.forth200x.org $(ICON_DIR)/icon.png $(CONTENTS_DIR)/Info.plist \
     $(RESOURCES_DIR)/docSet.dsidx

$(HTML_DIR)/www.forth200x.org: $(HTML_DIR)
	cd $(HTML_DIR) && wget -nv -r $(SOURCE_URL)

$(HTML_DIR):
	mkdir -p $@

$(CONTENTS_DIR)/Info.plist: $(HTML_DIR)
	cp Info.plist $@

$(ICON_DIR)/icon.png: icon.png
	cp icon.png $@

$(RESOURCES_DIR)/docSet.dsidx: schema.sql mkidx.awk
	sqlite3 $@ < schema.sql
	find $(HTML_DIR) -type f -name '*.html' -exec ./mkidx.awk {} \+ | sqlite3 $@

dist: all
	tar -czf Forth.tgz -C build forth.docset

clean:
	rm -rf build Forth.tgz *~
