################################################################################
################################################################################
#
# Windjay wiki makefile.
#
################################################################################
################################################################################

#
# Directory structure.
#

TOP := $(PWD)
TOOLS_DIR := $(TOP)/tools
BUILD_DIR := $(TOP)/build
SRC_DIR := $(TOP)/src


#
# Default target.
#

.PHONY: all
all: windjay_wiki


#
# Clean target.
#

.PHONY: clean
clean:
	rm -Rf tools build


#
# Windjay wiki target.
#

.PHONY: windjay_wiki
windjay_wiki: tools $(BUILD_DIR)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)


#
# Wiki page targets.
#

# Build all MD source files into HTML files.
MD_SRC_FILES := $(wildcard $(SRC_DIR)/*.md)
HTML_FILES := $(MD_SRC_FILES:$(SRC_DIR)/%.md=$(BUILD_DIR)/%.html)

# Add HTML files to the Windjay wiki target.
windjay_wiki: $(HTML_FILES)

# Rule to build an HTML file from an MD source file.
$(BUILD_DIR)/%.html : $(SRC_DIR)/%.md
	$(TOOLS_DIR)/bin/cmark $< > $@


#
# Tools target.
#

.PHONY: tools
tools: cmark

$(TOOLS_DIR):
	mkdir $(TOOLS_DIR)


#
# cmark target.
#

.PHONY: cmark
cmark: tools/bin/cmark

tools/bin/cmark: $(TOOLS_DIR)
	git clone https://github.com/jgm/cmark.git
	make -C cmark INSTALL_PREFIX=$(TOOLS_DIR)
	make -C cmark test
	make -C cmark install
	rm -Rf cmark

