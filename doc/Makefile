##
## Makefile to compile the manual
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

$(DELIVERABLE).pdf: $(DELIVERABLE).tex $(DELIVERABLE).bib Makefile commands.tex software-list.tex
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

$(DELIVERABLE)-arxiv.tex: to-arxiv.pl $(DELIVERABLE).tex
	./to-arxiv.pl < $(DELIVERABLE).tex > $(DELIVERABLE)-arxiv.tex
	perl -pi -e 's/\{content\}/\{content-arxiv\}/g' $(DELIVERABLE)-arxiv.tex

software-list: software-list.tex ../software-list.md
software-list.tex ../software-list.md: generate-software-list.sh
	@echo "Generating software list. Don't forget to run make afterwards to recompile the manual."
	./generate-software-list.sh
	mv -f software-list.md ..

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
