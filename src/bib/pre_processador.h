#pragma once
#include <string>

// namespace do processador
namespace pre_processador {

    // imprime informando que estamos fazendo o pre processador
    void print();

    // faz o pre processamento dado um filename
    // o filename deve vir sem extensao
    void processa(std::string filename);
}

  