// fazer o processamento para objeto aqui
#pragma once
#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include <map>

namespace processa_objeto {

    struct Erro{
        // Struct Erro 
        // tipo -> tipo de erro
        // mensagem -> mensagem do erro 
        std::string tipo;
        std::string mensagem;

        //ajuda na hora de usar funcoes como o emplace_back, sem a necessidade de criar uma variavel auxiliar
        Erro(std::string tipo, std::string mensagem):tipo(tipo),  mensagem(mensagem){};

    };

    // struct Line
    // baseado que toda linha possui o formato
    // <rotulo>: <operador> <operandos> ; <comentarios>
    // em que <operandos> podem ser 0 ate 3 operandos
    struct Line {
        std::string rotulo;
        std::string operacao;
        std::vector<std::string> operadores;
        bool vazio = 0;
        bool erro = 0;

        bool empty();
        void flush(std::ofstream &fileoutput);
        bool read(std::ifstream &fileinput);
        void update_arg(std::map<std::string, int> indexOf);
        void print();
        Line();
        Line(std::string s);
    };

    // struct ? 
    void traducao(std::string filename);

}