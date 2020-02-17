###############################################################################
##                                 Makefile                                  ##
###############################################################################

FILE = main

#### low quality
OPTIMIZATION = default
#OPTIMIZATION = screen
#OPTIMIZATION = ebook
#OPTIMIZATION = printer
#OPTIMIZATION = prepress
#### high quality

D_OPT = "rungs -q -dNOPAUSE -dBATCH -dEPSCrop -sDEVICE=pdfwrite -dCompatibilityLevel=%v -dPDFSETTINGS=/$(OPTIMIZATION) -sOutputFile='%o' '%i' -c quit" # see dvipdfmx.cfg
##D_OPT = "ps2pdf -dCompatibilityLevel=%v -sPAPERSIZE=a0 -dPDFSETTINGS=/$(OPTIMIZATION) %i %o"

###############################################################################
###############################################################################
###############################################################################

pdf:
	buf_size=9999999 platex -halt-on-error -kanji=utf8 -kanji-internal=utf8 $(FILE).tex
	bibtex $(FILE)
	dvipdfmx -f yu.map -p a4 -d 5 -z 9 -V 5 -I 24 -D $(D_OPT) -o $(FILE).pdf $(FILE).dvi
	touch $(FILE).pdf
	wmctrl -R $(PWD)/$(FILE).pdf || okular $(FILE).pdf > /dev/null 2>&1 &

###############################################################################

all: fig pdf

###############################################################################

fig:
	@DIRS=$$(find ./ -maxdepth 1 -mindepth 1 -type d);\
	for i in $$DIRS; do\
		cd "$$i";\
		if [ -f Makefile ]; then\
		make || exit 1;\
		fi;\
		cd ..;\
	done

###############################################################################
###############################################################################
###############################################################################

clean:
	rm -f *~ $(FILE).aux $(FILE).log $(FILE).bbl $(FILE).blg $(FILE).spl  $(FILE).txt
	@DIRS=$$(find ./ -maxdepth 1 -mindepth 1 -type d);\
	for i in $$DIRS; do\
		cd "$$i";\
		if [ -f Makefile ]; then\
			make clean || exit 1;\
		fi;\
		cd ..;\
	done

###############################################################################

fullclean: clean
	rm -f $(FILE).toc $(FILE).lot $(FILE).lof $(FILE).out $(FILE).dvi $(FILE).ps $(FILE).pdf *.eps *.pdf
