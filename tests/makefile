TEX := lualatex
FLAGS := -synctex=1 -src-specials -interaction=nonstopmode
BIB := biber
CC := latexmk -pdf -pdflatex="$(TEX) $(FLAGS)" -use-make #-output-directory=$(AUX)

.PHONY: all

all: test.pdf

%.pdf: %.tex
	$(CC) $(MASTER)
