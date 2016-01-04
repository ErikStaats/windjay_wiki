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
#   TOP                     Top of source tree.
#   TOOLS_DIR               Tools directory.
#   BUILD_DIR               Build directory.
#   SRC_DIR                 Source directory.
#

TOP := $(PWD)
TOOLS_DIR := $(TOP)/tools
BUILD_DIR := $(TOP)/build
SRC_DIR := $(TOP)/src


#
# Target variables.
#
#   HTML_FILES              List of HTML target files.
#

HTML_FILES :=


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
# Install target.
#
#   This target will install the Windjay wiki on the Windjay wiki server.
#

.PHONY: install
install:
	scp $(call list_files,$(BUILD_DIR)) \
            windjayd@windjay.com://home1/windjayd/public_html/wiki


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

# Copy all install source files to the build directory.
INSTALL_SRC_FILES := $(SRC_DIR)/.htaccess
INSTALL_FILES := $(INSTALL_SRC_FILES:$(SRC_DIR)/%=$(BUILD_DIR)/%)

# Add install files to the Windjay wiki target.
windjay_wiki: $(INSTALL_FILES)

# Rule to copy an install source file to the build directory.
$(BUILD_DIR)% : $(SRC_DIR)/%
	cp $< $@


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


################################################################################
#
# Functions.
#

#
# Return the list of files in the directory specified by $(1).
#
#   $(1)                    Directory from which to list files.
#

list_files = $(addprefix $(1)/,$(shell ls -1A $(1)))


