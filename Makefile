SOURCE_URL=http://www.forth200x.org/documents/html/index.html

ICON_DIR=build/forth.docset
CONTENTS_DIR=build/forth.docset/Contents
RESOURCES_DIR=$(CONTENTS_DIR)/Resources
DOCSET_DIR=$(RESOURCES_DIR)/Documents

all: download $(ICON_DIR)/icon.png $(CONTENTS_DIR)/Info.plist $(RESOURCES_DIR)/docSet.dsidx

download: $(DOCSET_DIR)
	[ -f build/.cached ] || \
	  ( cd $(DOCSET_DIR) && wget -nv -r $(SOURCE_URL) ) && touch build/.cached

$(DOCSET_DIR):
	mkdir -p $(DOCSET_DIR)

$(CONTENTS_DIR):
	mkdir -p $(CONTENTS_DIR)

$(CONTENTS_DIR)/Info.plist: $(CONTENTS_DIR)
	cp Info.plist $(CONTENTS_DIR)

$(ICON_DIR)/icon.png: icon.png
	cp icon.png $(ICON_DIR)/icon.png

$(RESOURCES_DIR)/docSet.dsidx: schema.sql
	sqlite3 $(RESOURCES_DIR)/docSet.dsidx < schema.sql
	find $(DOCSET_DIR) -type f -name '*.html' -exec ./mkidx.awk {} \; \
	| sqlite3 $(RESOURCES_DIR)/docSet.dsidx

clean:
	rm -rf build  *~
