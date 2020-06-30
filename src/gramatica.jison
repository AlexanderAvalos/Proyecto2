/*
* analizador lexico
*/

%lex 

%options case-insensitive

%% 

//reservadas
"int"           return 'INT';
"double"        return 'DOUBLE';
"char"          return 'CHAR';
"string"        return 'STRING';
"bool"          return 'BOOL';
"void"          return 'VOID';
"main"          return 'MAIN';
"if"            return 'IF';
"else"          return 'ELSE';
"for"           return 'FOR';
"while"         return 'WHILE';
"do"            return 'DO';
"switch"        return 'SWITCH';
"case"          return 'CASE';
"break"         return 'BREAK';
"default"       return 'DEFAULT';
"return"        return 'RETURN';
"continue"      return 'CONTINUE';
"Console"       return 'CONSOLE';
"Write"         return 'WRITE';
"true"          return 'TRUE';
"false"         return 'FALSE';

//simbolos
";"              return 'PYCOMA';
","              return 'COMA';
"="              return 'IGUAL';
"}"              return 'LLAVEDER';
"{"              return 'LLAVEIZQ';
"("              return 'PARIZQ';
")"              return 'PARDER';
">"              return 'MAYOR';
"<"              return 'MENOR';
"!"              return 'INTERROGACION';
"&&"             return 'AND';
"||"             return 'OR';
"!="             return 'DIFERENTE';
"=="             return 'IGUALIGUAL';
">="             return 'MAYORIGUAL';
"<="             return 'MENORIGUAL';

//SIGNOS
"."              return 'PUNTO';
"+"              return 'MAS';
"-"              return 'MENOS';
"/"              return 'DIVISION';
"*"              return 'MULTIPLICACION';

//ESPACIOS EN BLANCO

[ \r\t]+           {}
\n                 {}

//EXPRESIONES REGULARES

\s+ 
[0-9]+("."[0-9]+)?\b                         return 'DECIMAL';
[0-9]+\b                                     return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]*                      return 'ID';
'\'.\''\b                                    return 'CARACTER';
"\"[^\"]*\"                                  {yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
"//".*	                                     
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]          

<<EOF>>                                      return 'EOF';

.                               {console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }

/lex

%%star s

%% /* definicion de la gramatica*/


s 
        :   instrucciones EOF  {return $1;} 
;

instrucciones 
        :   instrucciones instruccion {$1.push($2); $$ = $1;  }
        |   instruccion { $$ = [$1]; }
;

instruccion: 
        :   declaracion {return $1;}
        |   asignacion  {return $1;}
        |   main        {return $1;}
        |   metodo      {return $1;}
        |   funcion     {return $1;}
;

declaracion 
        :   tipo declaraciones PYCOMA {}
;

declaraciones 
        :   declaraciones COMA decla {}
        |   decla                    {return $1;} 
;

 decla  
        :   ID IGUAL operacion   {}
        |   ID                   {}
;
 
main    
        :   VOID MAIN PARIZQ PARDER LLAVEIZQ sentencias LLAVEDER {}
;

metodo 
        :   VOID ID PARIZQ PARDER LLAVEIZQ sentencias LLAVEDER
        |   VOID ID PARIZQ parametros PARDER LLAVEIZQ sentencias LLAVEDER
;

parametros 
        :   parametros COMA parametro {$1.push($3); $$ = $1;}
        |   parametro                 {$$ = [$1]; }
;

parametro  
        :   tipo ID 
;

funcion 
        :   tipo ID PARIZQ PARDER LLAVEIZQ sentencias LLAVEDER
        |   tipo ID PARIZQ parametros PARDER LLAVEIZQ sentencias LLAVEDER
;   

sentencias
        :   sentencias sentencia {$1.push($2); $$ = $1}
        |   sentencia            {$$ = [$1]}
;

Sentencia 
        :   declaracion   {return $1;}
        |   asignacion    {return $1;}
        |   if            {return $1;}
        |   while         {return $1;}
        |   for           {return $1;}
        |   do_while      {return $1;}
        |   switch        {return $1;}
        |   break         {return $1;}
        |   return        {return $1;}
        |   continue      {return $1;}
        |   print         {return $1;} 
        |   callMetodo    {return $1;}
;

asignacion 
        :   ID IGUAL operacion PYCOMA {}
;

if 
        :   IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER                  {}
        |   IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER ELSE LLAVEIZQ sentencias LLAVEDER {}
        |   IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER else_if          {}
        |   IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER else_if ELSE LLAVEIZQ sentencias LLAVEDER {}
;

else_if 
        :   else_if elif            {$1.push($2); $$ = $1;}
        |   elif                    {$$ = [$1];}
;

elif 
        :   ELSE IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER 
;

while 
        :   WHILE PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER
;

do_while 
        :   DO LLAVEIZQ sentencias LLAVEDER WHILE PARIZQ operacion PARDER PYCOMA 
;

for 
        :   FOR PARIZQ inicializacion PYCOMA operacion PYCOMA incremento PARDER LLAVEIZQ sentencias LLAVEDER
;

inicializacion 
        :   tipo ID IGUAL operacion 
        |   ID IGUAL operacion 
;

incremento 
        :   ID MAS MAS 
        |   ID MENOS MENOS
;

callMetodo 
        :   ID PARIZQ PARDER PYCOMA
        |   ID PARIZQ valores PARDER PYCOMA
;

print 
        :   CONSOLE PUNTO WRITE PARIZQ CADENA COMA valores PARDER PYCOMA
        |   CONSOLE PUNTO WRITE PARIZQ CADENA MAS valores PARDER PYCOMA
        |   CONSOLE PUNTO WRITE PARIZQ CADENA PARDER PYCOMA
        |   CONSOLE PUNTO WRITE PARIZQ CSIMPLE valores CSIMPLE PARDER PYCOMA
;

valores 
        :   valores COMA operacion
        |   operacion
;

switch 
        :   SWITCH PARIZQ operacion PARDER LLAVEIZQ casos LLAVEDER
;

casos 
        :   casos caso                  {$1.push($2); $$ = $1;}
        |   caso                        {$$ = [$1];}
;

caso 
        :   CASE operacion DOSPUNTOS sentencias
        |   DEFAULT DOSPUNTOS sentencias
;

break 
        :   BREAK PYCOMA
;

continue 
        : CONTINUE PYCOMA
;

return 
        :   RETURN operacion PYCOMA
        |   RETURN PYCOMA
;

operacion 
        :   operacion   AND             operacion
        |   operacion   OR              operacion 
        |   operacion   IGUALIGUAL      operacion
        |   operacion   DIFERENTE       operacion 
        |   operacion   MAYOR           operacion
        |   operacion   MENOR           operacion
        |   operacion   MAYORIGUAL      operacion
        |   operacion   MENORIGUAL      operacion
        |   operacion   MAS             operacion
        |   operacion   MENOS           operacion
        |   operacion   MULTIPLICACION  operacion
        |   operacion   DIVISION        operacion
        |   operacion   INTERROGACION   operacion DOSPUNTOS operacion
        |   ID PARIZQ PARDER
        |   ID PARIZQ valores PARDER
        |   valor
;

tipo 
        :   INT
        |   DOUBLE
        |   CHAR
        |   ID
        |   STRING  
;    

valor 
        :   ENTERO
        |   ID
        |   DECIMAL
        |   CARACTER   
        |   CADENA  
        |   fALSE
        |   TRUE
;
