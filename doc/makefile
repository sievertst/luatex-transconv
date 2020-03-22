PROJ 	:= transconv
MASTER 	:= master
TEX 	:= lualatex
FLAGS 	:= -synctex=1 -src-specials -interaction=nonstopmode -file-line-error -halt-on-error
BIB 	:= biber
CC 		:= latexmk -pdf -pdflatex="$(TEX) $(FLAGS)" -use-make #-output-directory=$(AUX)

ROOT 	:= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
AUX 	:= $(ROOT)/.aux
AUXFILES_DEFAULT := *-tags.tex *.aux *.bbl *.blg *.bcf *.fdb_latexmk *.fls *.lof *.log *.lot *.out *.run.xml *.synctex.gz *.toc
AUXFILES_MORE := *.glg *.glstex
SETTINGS := $(shell find $(ROOT)/settings -name '*.tex')

all:
	make -i unclean
	make -i $(MASTER).pdf
	rm -f $(MASTER).pdf
	make -i $(MASTER).glstex
	make -i $(PROJ).pdf
	make clean

$(PROJ).pdf: $(MASTER).pdf $(MASTER).glstex
	cp $(MASTER).pdf $(PROJ).pdf

$(MASTER).pdf: $(MASTER).tex $(SETTINGS)
	$(CC) $(MASTER)

$(MASTER).glstex: $(MASTER).aux
	bib2gls --group $(MASTER)

############
# CLEAN UP #
############
clean :
	rsync -au --ignore-missing-args $(AUXFILES_DEFAULT) $(AUXFILES_MORE) $(MASTER).pdf $(AUX)
	rm -f $(AUXFILES_DEFAULT) $(AUXFILES_MORE) $(MASTER).pdf

# reverse cleanup so files can be checked for dependencies
unclean :
	rsync -au $(AUX)/* $(ROOT)

cleanall :
	rm -Rf $(AUX)
	rm -f *.pdf

