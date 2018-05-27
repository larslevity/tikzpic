# Trivial Makefile to generate and move files to the appropriate directory.
# Copyright 2005, 2006, 2007 TeX Users Group.
# You may freely use, modify and/or distribute this file.

styles = lucmtime.sty lucbmath.sty lucidabr.sty lucidbrb.sty \
         lucidbry.sty lucmin.sty luctime.sty  
fd = lmrhlcm.fd omlhlcm.fd omlhlh.fd omshlcy.fd omshlh.fd omxhlcv.fd

default: $(styles) $(fd)

$(styles) $(fd): lucidabr.ins
	latex '\nonstopmode\input $<'

$(styles): lucidabr.dtx
$(fd): lucidabr.fdd

lucidabr.pdf: lucidabr.dtx
	pdflatex '\nonstopmode\input $<'

texmf = ../../..
install: $(styles) $(fd)
	mv -f $(styles) $(texmf)/tex/latex/lucidabr/
	mv -f $(fd) $(texmf)/tex/latex/lucidabr/
	rm -f lucfont.tex lucidabr.log lucidabr.aux
