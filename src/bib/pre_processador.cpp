#include "need.h"

namespace pre_processador {
    void print() {
        std::cout << "fazendo o pre processamento :)" << std::endl;
    }

    // tem que passar o filename sem extensao
    void processa(std::string filename) {
        
        // abre o filename com a extensao .ASM
        std::string finput = filename + ".asm";
        std::ifstream fileinput(finput);

        // Se o ifstream nao conseguir abrir o arquivo
        if(!fileinput.is_open()) {
            std::cout << "arquivo nao existe :(" << std::endl;
            return;
        }

        // abrindo/criando o arquivo destino
        std::string foutput = filename + ".pre";
        std::ofstream fileoutput(foutput);

        // de acordo com a especificacao
        // o EQU vai ser estar fora da secao TEXT
        // if e equ sempre serao usados de forma correta
        // no inicio do arquivo
        // basta acreditar que os testes serao assim
        
        // map para guardar os valores da EQU
        std::map<std::string, int> tabela; 
        // Struct Line para representar uma linha
        processa_objeto::Line linha;
        
        // enquanto for possivel ler uma linha 
        // do arquivo de entrada
        while(linha.read(fileinput)) {
            
            // ignora linha em branco
            if(linha.empty()) continue;
            
            // vai dar erro, se der tempo corrigir, ARRUMAR, que tipo de  erro daria?
            if(linha.operacao == "equ") {//se for equ, transforma em numero, pois le como string
                tabela[linha.rotulo] = helper::str2num(linha.operadores[0]);
            }else if(linha.operacao == "if") { 
                // processa o comando if
                processa_objeto::Line linha2(helper::join(helper::get_next_valid_line(fileinput), ' '));
                if(tabela[linha.operadores[0]])
                    linha2.flush(fileoutput);
            }else {
                // guarda tudo o que nao for IF e EQU
                // trocando as constantes criadas em EQU
                // pelo seu valor real
                for(auto &it: linha.operadores)
                    if(tabela.find(it) != tabela.end())
                        it = std::to_string(tabela[it]);
                linha.flush(fileoutput);
            }
        }

        fileinput.close();
        fileoutput.close();
    }
}
