#include "bib/need.h"

int main(int argc, char *argv[]) {

    // se nao passar nenhum argumento para o exec
    if(argc == 1) {
        std::cout << "informe um arquivo para ser traduzido" << std::endl;
        return 0;
    }

    std::string filename(argv[1]);

    pre_processador::processa(filename);
    std::cout << "Pre processamento de remocao de EQU e IF finalizado" << std::endl;
    processa_objeto::traducao(filename);
}
