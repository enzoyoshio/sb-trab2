#include "need.h"

namespace processa_objeto {
    
    void Line::update_arg(std::map<std::string, int> indexOf) {
        this->operadores = helper::update_arg(this->operadores, indexOf);
    }

    bool Line::read(std::ifstream &fileinput) {
        // if(fileinput.eof()) return false;
        std::string s;
        getline(fileinput, s);
        *this = (Line(s));
        return (!fileinput.eof()) || (!this->empty());
    }

    void Line::flush(std::ofstream &fileoutput) {
        if(this->vazio) return;

        if(this->rotulo != "") 
            fileoutput << this->rotulo << ": ";

        if(this->operacao != "") {
            fileoutput << this->operacao << " ";
            char c = ' ';
            if(this->operacao == "copy" || this->operacao == "macro")
                c = ',';

            std::string s;
            for(auto it: this->operadores)
                s += it, s += c;
            if(s.size()) {
                s.pop_back();
                fileoutput << s;
            }

        }
        fileoutput << '\n';
    }

    bool Line::empty() {
        return this->vazio;
    }

    Line::Line() {
        this->erro = 0;
        this->operacao = "";
        this->operadores = {};
        this->rotulo = "";
        this->vazio = 0;
    }

    Line::Line(std::string s) {
        *this = Line();

        s = helper::join(helper::remove_comments(s), ' ');

        if(s.empty() || s == "") {
            this->vazio = true;
            return;
        }
        // std::cout << "\n\ndentro do line cosntructor\n";
        // std::cout << s << '\n';

        auto pos = s.find(":");
        std::vector<std::string> tok;
        // caso nao exista label
        if(pos == std::string::npos) {
            this->rotulo = "";
            tok = helper::parser(s, ' ');
        }else { // caso tenha label
            tok = helper::parser(s, ':');
            this->rotulo = tok[0]; // pega o primeiro e rotula

            // se tiver mais de duas definicoes
            if(tok.size() > 2) this->erro = true; 
            
            // se nao for um rotulo sozinho
            if(tok.size() > 1) 
                tok = helper::parser(tok[1], ' ');
            else tok = {}; // aqui eh um rotulo sozinho
        }
        
        if(tok.size()) {
            // a operacao vai ser a primeira
            this->operacao = tok[0];
            tok.erase(tok.begin());
            // vou levar aluns pontos em consideracao
            if(this->operacao == "copy") {
                tok = helper::parser(helper::join(tok, ' '), ',');
            }else {
                if(this->operacao == "macro") {
                    tok = helper::parser(helper::join(tok, ' '), ',');
                }
            } 
            for(auto it: tok)
                this->operadores.push_back(it);    
        }

        this->rotulo = helper::trim(helper::tolower(this->rotulo));
        this->operacao = helper::trim(helper::tolower(this->operacao));
        for(auto &it: this->operadores)
            it = helper::trim(helper::tolower(it));
    }

    void Line::print() {
        std::cout << "rotulo = " << this->rotulo << '\n';
        std::cout << "operacao = " << this->operacao << '\n';
        for(auto it: this->operadores)
            std::cout << "operadores = " << it << ' ';
        std::cout << '\n';
    }

    void traducao(std::string filename) {

        std::ifstream fileinput(filename + ".pre");

        if(!fileinput) {
            std::cout << "arquivo nao encontrado :(" << std::endl;
            return;
        }

        std::ofstream fileoutput(filename + ".S");

        // guardar as variaveis locais
        std::vector<std::string> bss = {"section .bss"}, data = {"section .data", "report db 'Quantidade de Bytes lidos/escritos = '"};

        // colocar aqui as funcoes para ler e escrever
        // lembrar de usar pusha e popa antes de chamar a funcao
        // e ja colocar nos argumento ecx e edx as info necessarias
        std::vector<std::string> inout = {
            "input_c:\n",
            "mov eax, 3\n",									
            "mov ebx, 1\n",	
            "int 0x80\n",
            "ret\n",


            "input_s:\n",
            "mov eax, 3\n",									
            "mov ebx, 1\n",	
            "int 0x80\n",
            "ret\n",

            "output_c:\n",
            // "mov edx, 10\n",
            // "mov ecx, msg\n",
            "mov ebx, 1\n",									
            "mov eax, 4\n",								
            "int 0x80\n",
            "ret\n",									


            "output_s:\n",
            // "mov edx, 10\n",
            // "mov ecx, msg\n",
            "mov ebx, 1\n",									
            "mov eax, 4\n",								
            "int 0x80\n",
            "ret\n",									

        
        };
        // saber se eu estou no campo de dados
        bool inData = false; 
        // simulando o registrador unico do assembly inventado
        // caso eu nao vao usar o eax, posso so vir aqui e trocar essa variavel
        std::string acc = "eax";
        // tenho que simular os pontos? 
        // fazer uma primeira passagem para pegar os endereços dos labels? 

        Line linha;
        while(linha.read(fileinput)) {
            auto& [rotulo, operacao, operadores, vazio, erro] = linha;

            // se a linha possui um rotulo
            // arruma aqui
            if(operacao == "section" && operadores[0] == "text") {
                fileoutput << "section .text\n";
                fileoutput << "global _start\n";
                fileoutput << "_start:\n";
            }else if(operacao == "section" && operadores[0] == "data") {
                inData = true;
            }else if(inData) {
                // fazer quando chegar a parte de dados
                // lembrar de dividir em bss e data
                // space -> bss
                // const -> data
                if(operacao == "space") {

                }else {

                }
            }else {

                if(rotulo != "") {
                    // coloco em uma linha separada? 
                    // acho que fica melhor para visualizar
                    fileoutput << rotulo << ":" << std::endl;
                }
                
                if(operacao == "stop") {
                    // esses tres comandos sao o exit no assembly
                    fileoutput << "mov eax,1" << std::endl;
                    fileoutput << "mov ebx,0" << std::endl;
                    fileoutput << "int 0x80" << std::endl;
                }else if(operacao == "add" || operacao == "sub") {
                    // basicamente esta fazendo
                    // ope acc,variavel
                    // e se for uma label? tenho que colocar entre parenteses? 
                    fileoutput << operacao << ' ' << acc << ",[" << operadores[0] << "]" << std::endl;
                }else if(operacao == "mul" || operacao == "div") {
                    
                    fileoutput << operacao << " [" << operadores[0] << "]" << std::endl;
                }else if(operacao == "jmp") {
                    fileoutput << operacao << ' ' << operadores[0] << std::endl;
                }else if(operacao == "jmpn") {
                    fileoutput << "cmp " << acc << ",0" << std::endl;
                    fileoutput << "jl " << operadores[0] << std::endl;
                }else if(operacao == "jmpp") {
                    fileoutput << "cmp " << acc << ",0" << std::endl;
                    fileoutput << "jg " << operadores[0] << std::endl;
                }else if(operacao == "jmpz") {
                    fileoutput << "cmp " << acc << ",0" << std::endl;
                    fileoutput << "je " << operadores[0] << std::endl;
                }else if(operacao == "copy") {
                    // copy A,B -> mov B,A
                    // tenho que colocar em parenteses acho q sim

                    // mov ebx,[mem1]
                    // mov [mem2],ebx
                    fileoutput << "mov ebx,[" << operadores[0] << "]" << std::endl;
                    fileoutput << "mov [" << operadores[1] << "],ebx" << std::endl;  
                }else if(operacao == "load") {
                    // load A
                    // mov eax,[A]
                    fileoutput << "mov " << acc << ",[" << operadores[0] << "]" << std::endl;
                }else if(operacao == "store") {
                    fileoutput << "mov [" << operadores[0] << "]," << acc << std::endl;
                }else if(operacao == "input") {
                    // le inteiro
                }else if(operacao == "input_c") {
                    // le um char
                    fileoutput << "pusha" << std::endl;
                    fileoutput << "mov ecx," << operadores[0] << std::endl;
                    fileoutput << "mov edx,1"<< std::endl;
                    fileoutput << "call input_c" << std::endl;
                    fileoutput << "popa" << std::endl;
                }else if(operacao == "input_s") {
                    // le array de char
                    fileoutput << "pusha" << std::endl;
                    fileoutput << "mov ecx," << operadores[0] << std::endl;
                    fileoutput << "mov edx," << operadores[1] << std::endl;
                    fileoutput << "call input_s" << std::endl;
                    fileoutput << "popa" << std::endl;
                }else if(operacao == "output") {
                    // imprime um inteiro
                }else if(operacao == "output_c") {
                    // imprime um char
                    fileoutput << "pusha" << std::endl;
                    fileoutput << "mov ecx," << operadores[0] << std::endl;
                    fileoutput << "mov edx,1"<< std::endl;
                    fileoutput << "call output_c" << std::endl;
                    fileoutput << "popa" << std::endl;
                }else if(operacao == "output_s") {
                    // imprime um array de char
                    fileoutput << "pusha" << std::endl;
                    fileoutput << "mov ecx," << operadores[0] << std::endl;
                    fileoutput << "mov edx," << operadores[1] << std::endl;
                    fileoutput << "call output_s" << std::endl;
                    fileoutput << "popa" << std::endl;
                }
            }
        }
    }
}

// to do
// definir algum registrador como o acc do assembly inventado
// ate o momento estou usando o eax

// fazer os base case para todas as operacoes
// fazer as traducoes
// assembly inventado -> nasm
// ADD N -> add eax, N
// SUB N -> sub eax, N
// MUL N -> mul eax, N
// DIV N -> mul eax, N
// JMP N -> jmp n

// para as comparacoes, tem q usar o cmp e dps os jmp

// JMPN N -> search for jumpn command in nasm
// JMPP N -> search for jumpp command in nasm
// JMPZ N -> search for jumpz command in nasm
// COPY A,B -> mov B,A

// LOAD N -> mov eax,N (?) search how to use memory
// STORE -> search

// tem que implementar em nasm essas operacoes abaixo
// INPUT 
// INPUT_C 
// INPUT_S
// OUTPUT 
// OUTPUT_C
// OUTPUT_S

// STOP 
// just change stop with this three commands
// mov eax,1
// mov ebx,0
// int 80h