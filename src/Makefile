tradutor: tradutor.cpp ./bib/pre_processador.h ./bib/pre_processador.cpp ./bib/processa_objeto.h ./bib/processa_objeto.cpp ./bib/helper.h ./bib/helper.cpp
	g++ bib/helper.cpp -c -std=c++17
	g++ bib/pre_processador.cpp -c -std=c++17 
	g++ bib/processa_objeto.cpp -c -std=c++17
	g++ tradutor.cpp -o tradutor pre_processador.o processa_objeto.o helper.o 
	rm *.o