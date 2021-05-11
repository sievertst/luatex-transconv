TEXDIR := $$HOME/texmf/
TEXPKG := $(TEXDIR)/tex/latex/local/transconv.sty
LUAMOD := $(TEXDIR)/scripts/transconv

install :
	cp ./transconv.sty $(TEXPKG)
	cp -R ./lua/transconv/ $(LUAMOD)/

uninstall :
	rm $(TEXPKG)
	rm -R $(LUAMOD)
