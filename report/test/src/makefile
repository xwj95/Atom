all: test.pdf test.tex package.tex part1.tex part2.tex part3.tex part4.tex part5.tex renew.tex title.tex

test.pdf: test.tex package.tex part1.tex part2.tex part3.tex part4.tex part5.tex renew.tex title.tex
	pdflatex test.tex
	java -classpath . Charset2Unicode UTF-8 test.out
	pdflatex test.tex

make clean:
	rm *.aux *.log *.out *.out.bak *.toc 
