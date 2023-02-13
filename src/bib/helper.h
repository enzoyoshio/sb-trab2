#pragma once
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <cctype>
#include <map>

namespace helper {

    // le uma linha do arquivo 
    // e retorna os tokens parseados por espaco 
    std::vector<std::string> get_tokens(std::ifstream &file);

    // divide a string s em tokens, 
    // usa como delimitador o char c
    std::vector<std::string> parser(std::string s, char c);

    // remove os comentarios do assembly inventado
    // apos a linha ja ter virado uma lista de tokens
    std::vector<std::string> remove_comments(std::vector<std::string> v);

    // remove os comentarios e ainda transforma o resto em tokens
    std::vector<std::string> remove_comments(std::string s); // acho que essa versao eh melhor q a de cima

    // junta uma lista de strings em uma lista so
    // usando o char c como intermediario entre duas ocorrencias
    std::string join(std::vector<std::string> v, char c);

    //tolower para strings
    std::string tolower(std::string s);

    //tolower para vetor de string
    std::vector<std::string> tolower(std::vector<std::string> v);

    //toupper para strings
    std::string toupper(std::string s);

    //toupper para vetor de string
    std::vector<std::string> toupper(std::vector<std::string> v);

    // converte uma string para inteiro
    // pode ser tanto hexadecimal quanto decimal
    int str2num(std::string);

    // pega proxima linha valida
    // ou seja, elimina linhas em branco
    // ou que so tenham comentario
    std::vector<std::string> get_next_valid_line(std::ifstream &file);

    // ao popular a MDT,  devemos substiuir os argumentos 
    // por tokens que o montador ira reconhecer,
    // essa funcao trocar os argumentos por um argumento do montador 
    std::vector<std::string> update_arg(std::vector<std::string> v, std::map<std::string,int> m);

    // remove espacos da esquerda e direita  
    std::string trim(std::string s);
    
    // remove espacos a esquerda
    std::string ltrim(std::string s);

    // remove espacos a direita
    std::string rtrim(std::string s);
    
    // funcao para jogar o conteudo de vector<T> v 
    // no file
    template <typename T>
    void flushline(std::ofstream &file, std::vector<T> v) {
        for(auto it: v) file << it << ' '; file << '\n';
    }

    // checa se string s eh um simbolo valido
    // aqui consideramos 3 tipos de simbolo validos
    // 1 -> simbolo salvo na tabela de simbolo
    // 2 -> literal
    // 3 -> vetor do tipo X+2
    bool checkSymbol(std::string s, std::map<std::string, int> ts);

    // isnumber para string
    // reconhece padroes mais "complexos"
    // como sinais de + e - 
    // o simbolo 0x para numeros hexadecimais
    bool isnumber(std::string s);

    // isdigit para string 
    // apenas verifica se a string dada contem 
    // elementos no range [0, 9]
    bool isdigit(std::string s);

    // arrumar
    bool checkSim(std::string s);
}