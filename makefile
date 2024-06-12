PKGNAME := transconv
TEXDIR := $$HOME/texmf
TEXPKGDIR := $(TEXDIR)/tex/latex/local/
TEXPKG := $(TEXPKGDIR)/$(PKGNAME).sty
LUATARGETDIR := $(TEXDIR)/scripts/kpsewhich/lua

.PHONY: install uninstall

install : $(TEXPKG) $(LUATARGETDIR)/$(PKGNAME)/init.lua

$(TEXPKGDIR)/$(PKGNAME): $(TEXPKGDIR)
    cp ./$(PKGNAME).sty $(TEXPKGDIR)

$(LUATARGETDIR)/$(PKGNAME)/init.lua:
    cp -R ./lua/$(PKGNAME)/ $(LUATARGETDIR)/$(PKGNAME)/
	
$(TEXPKGDIR):
    mkdir -p $(TEXPKGDIR)

uninstall :
    rm $(TEXPKG)
    rm -R $(LUATARGETDIR)
