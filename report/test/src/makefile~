all: technical.pdf technical.tex package.tex part1.tex part2.tex part3.tex part4.tex renew.tex title.tex

technical.pdf: technical.tex package.tex part1.tex part2.tex part3.tex part4.tex renew.tex title.tex
	pdflatex technical.tex
	java -classpath . Charset2Unicode UTF-8 technical.out
	pdflatex technical.tex

make clean:
	rm *.aux *.log *.out *.out.bak *.toc 
