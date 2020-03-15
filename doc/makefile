PROJ := transconv
MASTER := master
TEX := lualatex
FLAGS := -synctex=1 -src-specials -interaction=nonstopmode -file-line-error -halt-on-error
BIB := biber
CC := latexmk -pdf -pdflatex="$(TEX) $(FLAGS)" -use-make #-output-directory=$(AUX)

ROOT := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
AUX := $(ROOT)/.aux
AUXFILES_DEFAULT := *-tags.tex *.aux *.bbl *.blg *.bcf *.fdb_latexmk *.fls *.lof *.log *.lot *.out *.run.xml *.synctex.gz *.toc
AUXFILES_MORE := *.glg *.glstex
CHAPTERS := $(shell find $(ROOT)/tex -name '*.tex')
SETTINGS := $(shell find $(ROOT)/settings -name '*.tex')

all:
	make mkdirs
	make -i unclean
	make -i $(MASTER).pdf
	rm -f $(MASTER).pdf
	make -i $(MASTER).glstex
	make -i $(PROJ).pdf
	make clean

$(PROJ).pdf: $(MASTER).pdf $(MASTER).glstex
	cp $(MASTER).pdf $(PROJ).pdf

$(MASTER).pdf: $(MASTER).tex $(CHAPTERS) $(SETTINGS)
	$(CC) $(MASTER)

$(MASTER).glstex: $(MASTER).aux
	bib2gls --group $(MASTER)

#############
# AUXILIARY #
#############
# prepare folders for included files in $(AUX) because latexmk needs them and
# cannot create them by itself
mkdirs :
	mkdir -p $(AUX)/tex
	rsync -au --exclude '*.tex' tex/ $(AUX)/tex/

############
# CLEAN UP #
############
clean :
	rsync -au --exclude '*.tex' tex/ $(AUX)/tex/
	find ./tex -name '*.aux' -exec rm -rf {} \;
	rsync -au --ignore-missing-args $(AUXFILES_DEFAULT) $(AUXFILES_MORE) $(MASTER).pdf $(AUX)
	rm -f $(AUXFILES_DEFAULT) $(AUXFILES_MORE) $(MASTER).pdf

# reverse cleanup so files can be checked for dependencies
unclean :
	rsync -au $(AUX)/* $(ROOT)

cleanall :
	find $(ROOT)/tex -name '*.aux' -exec rm -rf {} \;
	rm -Rf $(AUX)
	rm -f *.pdf
	rm -Rf tex/*/*.aux

