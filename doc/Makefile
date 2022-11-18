##
## Makefile to compile paper
##

#
# Settings
#

#PDFLATEXFLAGS = --interaction=batchmode --file-line-error-style
PDFLATEXFLAGS = --interaction=batchmode

DELIVERABLE = speed-manual
SUBMISSIONDIR = speed-manual

DELIVERABLEARXIV = speed-manual-arxiv
DELIVERABLEACM = speed-manual-acm

#
# Build
#

all: $(DELIVERABLE).pdf
#all: $(DELIVERABLE).pdf arxiv acm presentation
#all: arxiv acm
#all: arxiv

$(DELIVERABLE).pdf: $(DELIVERABLE).tex $(DELIVERABLE).bib Makefile
	@echo "Compiling *.tex files..."
	pdflatex $(PDFLATEXFLAGS) $(DELIVERABLE)
	@echo "Compiling bibliography..."
	bibtex $(DELIVERABLE)
	@echo "Updating cross-references..."
	pdflatex $(PDFLATEXFLAGS) $(DELIVERABLE)
	pdflatex $(PDFLATEXFLAGS) $(DELIVERABLE)

arxiv: $(DELIVERABLEARXIV).pdf

$(DELIVERABLEARXIV).pdf: $(DELIVERABLEARXIV).tex $(DELIVERABLE).bib content-arxiv.tex Makefile
	@echo "Compiling *.tex files..."
	pdflatex $(PDFLATEXFLAGS) $(DELIVERABLEARXIV)
	@echo "Compiling bibliography..."
	bibtex $(DELIVERABLEARXIV)
	@echo "Making index..."
	makeindex $(DELIVERABLEARXIV)
	@echo "Updating cross-references..."
	pdflatex $(PDFLATEXFLAGS) $(DELIVERABLEARXIV)
	pdflatex $(PDFLATEXFLAGS) $(DELIVERABLEARXIV)

content-arxiv.tex: content.tex
	./to-arxiv.pl < content.tex > content-arxiv.tex
	perl -pi -e 's/\\ouagadougou/\\BigSwitchOne/g' content-arxiv.tex
	perl -pi -e 's/\\petawawa/\\BigSwitchTwo/g' content-arxiv.tex
	perl -pi -e 's/\\EV/\\BLDOne/g' content-arxiv.tex
	perl -pi -e 's/\\Hall/\\BLDTwo/g' content-arxiv.tex
	perl -pi -e 's/\\CB/\\BLDThree/g' content-arxiv.tex
	perl -pi -e 's/\\FB/\\BLDFour/g' content-arxiv.tex

$(DELIVERABLE)-arxiv.tex: to-arxiv.pl $(DELIVERABLE).tex
	./to-arxiv.pl < $(DELIVERABLE).tex > $(DELIVERABLE)-arxiv.tex
	perl -pi -e 's/\{content\}/\{content-arxiv\}/g' $(DELIVERABLE)-arxiv.tex
	#perl -pi -e 's/\{encs-networking\}/\{encs-networking-arxiv\}/g' $(DELIVERABLE)-arxiv.tex

acm: $(DELIVERABLE)-acm.pdf

$(DELIVERABLE)-acm.pdf: $(DELIVERABLE)-acm.tex content-acm.tex Makefile
	@echo "ACM: Compiling *.tex files..."
	pdflatex $(PDFLATEXFLAGS) $(DELIVERABLE)-acm
	@echo "ACM: Compiling bibliography..."
	bibtex $(DELIVERABLE)-acm
	@echo "ACM: Updating cross-references..."
	pdflatex $(PDFLATEXFLAGS) $(DELIVERABLE)-acm
	pdflatex $(PDFLATEXFLAGS) $(DELIVERABLE)-acm

content-acm.tex: content.tex to-acm.pl
	./to-acm.pl < content.tex > content-acm.tex

$(DELIVERABLE)-acm.tex: to-acm.pl $(DELIVERABLE).tex
	./to-acm.pl < $(DELIVERABLE).tex > $(DELIVERABLE)-acm.tex
	perl -pi -e 's/\{content\}/\{content-acm\}/g' $(DELIVERABLE)-acm.tex
	perl -pi -e 's/\{encs-networking-arxiv\}/\{encs-networking\}/g' $(DELIVERABLE)-acm.tex

to-acm.pl: to-arxiv.pl
	ln -sf to-arxiv.pl to-acm.pl

presentation slides: $(DELIVERABLE)-presentation.pdf

$(DELIVERABLE)-presentation.pdf: $(DELIVERABLE)-presentation.tex $(DELIVERABLE).bib Makefile
	@echo "Compiling *.tex files..."
	pdflatex $(PDFLATEXFLAGS) $(DELIVERABLE)-presentation
	@echo "Compiling bibliography..."
	bibtex $(DELIVERABLE)-presentation
	@echo "Updating cross-references..."
	pdflatex $(PDFLATEXFLAGS) $(DELIVERABLE)-presentation
	pdflatex $(PDFLATEXFLAGS) $(DELIVERABLE)-presentation

figures-pdf:
	./figures-to-pdf.sh

%submission: all
submission:
	rm -rf $(SUBMISSIONDIR)
	mkdir -p $(SUBMISSIONDIR)
	cp Makefile *.tcp *.tex *.bib *.pdf $(SUBMISSIONDIR)
	mkdir -p $(SUBMISSIONDIR)/FIG
	#cp -f FIG/{before,after,during}.pdf FIG/{netmap,dbdiag,10GBASE}.png $(SUBMISSIONDIR)/FIG
	cp -f FIG/before.pdf FIG/after.pdf FIG/during.pdf \
		FIG/netmap.png FIG/dbdiag.png FIG/10GBASE.png \
		$(SUBMISSIONDIR)/FIG
	make -C $(SUBMISSIONDIR) clean
	tar cvf $(SUBMISSIONDIR).tar $(SUBMISSIONDIR)
	gzip --best $(SUBMISSIONDIR).tar

copy-to-nag: submission
	cp -f \
		Makefile $(DELIVERABLE).tcp $(DELIVERABLE)-{acm,arxiv,presentation}.tcp \
		$(DELIVERABLE).tex content.tex commands.tex \
		content-{acm,arxiv}.tex \
		$(DELIVERABLE)-{acm,arxiv,presentation}.tex \
		$(DELIVERABLE).bib $(DELIVERABLE)-arxiv.bib \
		$(DELIVERABLE)-{acm,arxiv,presentation}.pdf \
		easychair.cls sig-alternate.cls aliascnt.sty llncs.cls splncs03.bst \
		figures-to-pdf.sh \
		/groups/n/nag/papers/encs-networking
	cp -f $(SUBMISSIONDIR).tar.gz /groups/n/nag/papers
	mkdir -p /groups/n/nag/papers/encs-networking/FIG
	cp -f FIG/*.{pdf,png} /groups/n/nag/papers/encs-networking/FIG/
	chmod -R g+rwX /groups/n/nag/papers/encs-networking 2>/dev/null || cat /dev/null

# Building static HTML requires `make4ht`
# Works with existing environment
html:
		make4ht $(DELIVERABLE) -a debug mathjax -c speed-manual.cfg -d web && \
		mv ./web/$(DELIVERABLE).html ./web/index.html && \
		rm $(DELIVERABLE).html $(DELIVERABLE).css

#
# Clean up
#

clean:
	rm -f *~ *.log *.dvi *.aux *.toc \
          *.lot *.lof *.idx *.bbl *.blg *.ilg *.ind

maintainer-clean: clean
	rm -f *.pdf *.html *.css

# EOF
