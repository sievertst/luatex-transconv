TEXDIR := $$HOME/texmf
TEXPKG := $(TEXDIR)/tex/latex/local/transconv.sty
LUAMOD := $(TEXDIR)/scripts/kpsewhich/lua

install :
	cp ./transconv.sty $(TEXPKG)
	cp -R ./lua/transconv/ $(LUAMOD)/transconv/

uninstall :
	rm $(TEXPKG)
	rm -R $(LUAMOD)
