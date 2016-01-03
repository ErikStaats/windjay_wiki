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


#
# Default target.
#

.PHONY: all
all: windjay_wiki


#
# Windjay wiki target.
#

.PHONY: windjay_wiki
windjay_wiki: tools


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

