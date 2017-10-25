DOCUMENT        = main
THEME_FOLDER    = fu_beamer
BIN             = bin

###

TEX2PDF         = pdflatex
TEX2PDF_OPTS    = -halt-on-error

###

all: $(DOCUMENT).pdf

.PHONY: clean FORCE

$(DOCUMENT).pdf: %.pdf: $(BIN)/%.pdf
	cp $< $@

$(BIN)/$(DOCUMENT).pdf: $(BIN)/%.pdf: %.tex FORCE | $(BIN)
	TEXINPUTS=".:$(THEME_FOLDER):" $(TEX2PDF) $(TEX2PDF_OPTS) --output-directory=$(@D) $<
	TEXINPUTS=".:$(THEME_FOLDER):" $(TEX2PDF) --output-directory=$(@D) $<
	TEXINPUTS=".:$(THEME_FOLDER):" $(TEX2PDF) --output-directory=$(@D) $<

$(BIN):
	mkdir -p $(BIN)

clean:
	$(RM) *.pdf
	$(RM) -r $(BIN)

# Handle vim 'write then move' strategy
INOTIFYWAITEVENT ?= DELETE_SELF
buildloop:
	while true; do \
		inotifywait -e $(INOTIFYWAITEVENT) $(DOCUMENT).tex ;\
		make ;\
	done \
	#
