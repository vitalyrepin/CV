LATEX = latex
BIBTEX = bibtex
L2H = latex2html
PDFLATEX = pdflatex
DVIPS = dvips
MAIN_FNAME=cv

RERUN = "(There were undefined references|Rerun to get (cross-references|the bars) right)"

RERUNBIB = "No file.*\.bbl|Citation.*undefined"

GOALS = $(MAIN_FNAME).dvi $(MAIN_FNAME).pdf 
DVIFILES = $(MAIN_FNAME).dvi

COPY = if test -r $*.toc; then cp $*.toc $*.toc.bak; fi
RM = /bin/rm -f

main:           $(DVIFILES)

all:            $(GOALS)

$(MAIN_FNAME).dvi: $(MAIN_FNAME).tex
$(MAIN_FNAME).pdf: $(MAIN_FNAME).tex

%.dvi:          %.tex
		$(COPY);$(LATEX) $<
		egrep -c $(RERUNBIB) $*.log && ($(BIBTEX) $*;$(COPY);$(LATEX) $<) ; true
		egrep $(RERUN) $*.log && ($(COPY);$(LATEX) $<) ; true
		egrep $(RERUN) $*.log && ($(COPY);$(LATEX) $<) ; true
		if !(cmp -s $*.toc $*.toc.bak); then $(LATEX) $< ; fi
		$(RM) $*.toc.bak
# Display relevant warnings
		egrep -i "(Reference|Citation).*undefined" $*.log ; true 

%.pdf:  %.eps      
	epstopdf $<

%.pdf:          %.tex
		$(COPY);$(PDFLATEX) $<
		egrep -c $(RERUNBIB) $*.log && ($(BIBTEX) $*;$(COPY);$(PDFLATEX) $<) ; true
		egrep $(RERUN) $*.log && ($(COPY);$(PDFLATEX) $<) ; true
		egrep $(RERUN) $*.log && ($(COPY);$(PDFLATEX) $<) ; true
		if !(cmp -s $*.toc $*.toc.bak); then $(PDFLATEX) $< ; fi
		$(RM) $*.toc.bak
# Display relevant warnings
		egrep -i "(Reference|Citation).*undefined" $*.log ; true 

clean:          
		$(RM) -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
		*.inx *.ps *.dvi *.pdf *.toc *.out *.lot *.lof vra.tex
		
