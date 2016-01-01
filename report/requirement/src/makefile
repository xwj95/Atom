all: requirement.pdf requirement.tex package.tex part1.tex part2.tex part3.tex part4.tex part5.tex renew.tex table.tex title.tex

requirement.pdf: requirement.tex package.tex part1.tex part2.tex part3.tex part4.tex part5.tex renew.tex table.tex title.tex
	pdflatex requirement.tex
	java -classpath . Charset2Unicode UTF-8 requirement.out
	pdflatex requirement.tex

make clean:
	rm *.aux *.fdb_latexmk *.log *.out *.out.bak *.toc 
