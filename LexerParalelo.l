%option noyywrap

%{
  /** Actividad Integradora 5.3 - Resaltador de Sintaxis Paralelo
  * Diego Sú Gómez - A01620476
  * Implementation of Computational Methods
    Para compilación:
    Multiarchivo: flex .\LexerMultiarchivo.l
                  g++ .\lex.yy.c
                  .\a.exe
    Paralelo:     flex .\LexerMultiarchivo.l
                  g++ .\lex.yy.c -pthread
                  .\a.exe
  * Fecha de Entrega: Lunes 7 de junio de 2022 **/
  #pragma GCC diagnostic ignored "-Wformat-security"
  #pragma GCC diagnostic ignored "-Wreturn-type"
  #include <stdio.h>
  #include <iostream>
  #include <time.h>
  #include <dirent.h>
  #include <sys/stat.h>
  #include <string.h>
  #include <string>
  #include <queue>
  #include <pthread.h>
  using namespace std;
  extern int yylex();

  queue<string> archivos,htmls,paths;

%}

%%
[0-9]* {fprintf(yyout,"<span class=\"enteros\">");fprintf(yyout,yytext);}; //Enteros
[ ]+ {fprintf(yyout," ");};//Espacios
\n+ {fprintf(yyout,"<br/>");};//Salto de línea
[0-9]+[.][0-9]* {fprintf(yyout,"<span class=\"floats\">");fprintf(yyout,yytext);}; //Floats
"long"|"int"|"float"|"double"|"char"|"void"|"bool"|"void"|"FILE"|"string"|"short" {fprintf(yyout,"<span class=\"tipodato\">");fprintf(yyout,yytext);}; //Tipos Datos
"+"|"-"|"*"|"/"|"^"|"%"|"="|"**"|"%%"|"%/%"|"<-" {fprintf(yyout,"<span class=\"opa\">");fprintf(yyout,yytext);}; //Aritméticos
"<"|">"|"<="|">="|"=="|"&&"|"||"|"!="|"!"|"and"|"or"|"not" {fprintf(yyout,"<span class=\"opl\">");fprintf(yyout,yytext);}; //Lógicos
"true"|"True"|"False"|"false" {fprintf(yyout,"<span class=\"bools\">");fprintf(yyout,yytext);}; //Bools
"("|")"|"{"|"}"|":"|";"|"|"|"<<"|">>"|"," {fprintf(yyout,"<span class=\"seps\">");fprintf(yyout,yytext);}; //Separadores
"//"(.*) {fprintf(yyout,"<span class=\"commts\">");fprintf(yyout,yytext);}; //Comentarios
"#include"/[" ""<"](.*)[>] {fprintf(yyout,"<span class=\"libs\">");fprintf(yyout,yytext);};
"import"/[" "]?(.*) {fprintf(yyout,"<span class=\"libs\">");fprintf(yyout,yytext);};
"#"(.*) {fprintf(yyout,"<span class=\"commts\">");fprintf(yyout,yytext);};
"asm"|"auto"|"break"|"case"|"catch"|"class"|"const"|"continue"|"default"|"delete"|"do"|"else"|"enum"|"extern"|"for"|"friend"|"goto"|"if"|"inline"|"new"|"operator"|"private"|"protected"|"register"|"return"|"signed"|"sizeof"|"struct"|"switch"|"template"|"this"|"throw"|"try"|"typedef"|"union"|"unsigned"|"virtual"|"void"|"volatile"|"while" {fprintf(yyout,"<span class=\"prsv\">");fprintf(yyout,yytext);}; //Reservadas
"def"|"raise"|"import"|"None"|"del"|"elif"|"in"|"is"|"as"|"except"|"lambda"|"with"|"assert"|"finally"|"nonlocal"|"yield"|"from"|"global"|"pass" {fprintf(yyout,"<span class=\"prsv\">");fprintf(yyout,yytext);}; //Reservadas
"repeat"|"function"|"next"|"NULL"|"Inf"|"NaN"|"NA"|"NA_integer_"|"NA_real_"|"NA_complex_"|"NA_character_"|"using"|"namespace"|"std"|"cout"|"cin"|"printf"|"fprintf" {fprintf(yyout,"<span class=\"prsv\">");fprintf(yyout,yytext);}; //Reservadas
"exception"|"limits"|"new"|"typeinfo"|"stdexcept"|"utility"|"functional"|"memory"|"locale"|"algorithm"|"bitset"|"iterator"|"list"|"map"|"iostream"|"queue"|"stack"|"vector"|"deque"|"set"|"unordered_map"|"unordered_set"|"complex"|"numeric"|"valarray"|"fstream"|"iomanip"|"ios"|"iosfwd"|"istream"|"ostream"|"streambuf"|"sstream"|"strstream"|"cmath"|"ctime" {fprintf(yyout,"<span class=\"prsv\">");fprintf(yyout,yytext);}; //Reservadas
"array"|"random"|"regec"|"tuple"|"unordered_set"|"unordered_map"|"pandas"|"matplotlib"|"requests"|"numpy"|"sqlalchemy"|"beautifulsoup"|"pyglet"|"scipy"|"scrapy"|"pygame" {fprintf(yyout,"<span class=\"prsv\">");fprintf(yyout,yytext);}; //Reservadas
[a-zA-Z_][a-zA-Z0-9_]* {fprintf(yyout,"<span class=\"vrbls\">");fprintf(yyout,yytext);}; //Variables
(\"(\\.|[^"\\])*\") {fprintf(yyout,"<span class=\"strs\">");fprintf(yyout,yytext);}; //Strings
['][a-zA-Z0-9]*['] {fprintf(yyout,"<span class=\"strs\">");fprintf(yyout,yytext);}; //Strings
[a-zA-z_][a-zA-Z0-9_]*[*] {fprintf(yyout,"<span class=\"ptrs\">");fprintf(yyout,yytext);}; //Apuntador
[a-zA-Z]+[(][a-zA-Z0-9]*[)] {fprintf(yyout,"<span class=\"funcion\">");fprintf(yyout,yytext);}; //Funciones
%%

void* lexer(void *arg){
    DIR *dir;
    struct dirent *ent;
    if ((dir = opendir ("C:\\Users\\diego\\OneDrive\\Documentos\\ResaltadorSintaxisParalelo\\Archivos")) != NULL) { //Se añaden los archivos a una fila, se ajusta el path dependiendo de la ubicación del archivo
    while ((ent = readdir (dir)) != NULL) {
        archivos.push(ent->d_name);
    }
    closedir (dir);
    } else {
      perror ("");
    }
    archivos.pop();
    archivos.pop();
    for(int i = 0; archivos.size() > 0 ; i++){
        string path = "C:\\Users\\diego\\OneDrive\\Documentos\\ResaltadorSintaxisII\\Archivos";
        string nombre = archivos.front();
        path = path + "\\" + nombre;
        paths.push(path);
        nombre.resize(nombre.size()-4);
        nombre  = nombre + ".html";
        htmls.push(nombre);
        archivos.pop();
    }
    FILE *archivo = fopen(paths.front().c_str(),"r");
    FILE *html = fopen(htmls.front().c_str(),"w");
    paths.pop();
    htmls.pop();
    yyin = archivo;
    yyout = html;
    cout<<"Archivo leido correctamente"<<endl;
    fprintf(yyout,"<html><head><title>Resaltador L&eacutexico</title><link rel=\"stylesheet\"href=\"estilos.css\"</head>");
    fprintf(yyout,"<body id=\"fondo\"> <center><h1 id=\"titulo\"> Resaltador L&eacutexico </h1></center><p>");
    while(yylex());
    fprintf(yyout,"</br></p> <center><h2>Leyenda</h2></center>");
    fprintf(yyout,"<ul class=\"lyd\"> <li><span class=\"enteros\"></span>Enteros</li>");
    fprintf(yyout,"<li><span class=\"floats\"></span>Flotantes</li><li><span class=\"tipodato\"></span>Tipo De Dato</li>");
    fprintf(yyout,"<li><span class=\"opa\"></span>Operador Aritm&eacutetico</li><li><span class=\"opl\"></span>Operador L&oacutegico</li>");
    fprintf(yyout,"<li><span class=\"bools\"></span>Booleano</li><li><span class=\"seps\"></span>Separador</li>");
    fprintf(yyout,"<li><span class=\"commts\"></span>Comentarios</li><li><span class=\"libs\"></span>Librer&iacuteas</li>");
    fprintf(yyout,"<li><span class=\"prsv\"></span>Palabra Reservada</li><li><span class=\"vrbls\"></span>Variables</li>");
    fprintf(yyout,"<li><span class=\"strs\"></span>Strings</li><li><span class=\"ptrs\"></span>Apuntador</li><li><span class=\"funcion\"></span>Funci&oacuten</li>");
    fprintf(yyout,"</ul></br></html>");
    fclose(archivo);
    fclose(html);
}

int main() {
  double elapsed;
  elapsed = 0.0;
  clock_t inicio = clock();  
  int a;
  pthread_t h1;
  pthread_t h2;
  pthread_t h3;
  pthread_t h4;
  pthread_t h5;

  pthread_create(&h1, NULL, lexer, (void* )a);
  pthread_join(h1,NULL);
  pthread_create(&h2, NULL, lexer, (void* )a);
  pthread_join(h2,NULL);
  pthread_create(&h3, NULL, lexer, (void* )a);
  pthread_join(h3,NULL);
  pthread_create(&h4, NULL, lexer, (void* )a);
  pthread_join(h4,NULL);
  pthread_create(&h5, NULL, lexer, (void* )a);
  pthread_join(h5,NULL);

  clock_t final = clock();
  elapsed += (double)(final-inicio)/CLOCKS_PER_SEC;
  cout << "Tiempo de ejecucion: " << elapsed <<" segundos" << endl;
  return 0;

}