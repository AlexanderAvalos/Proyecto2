%lex

%options case-insensitive

%%
\s+											// se ignoran espacios en blanco
"//".*										// comentario simple línea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]			// comentario multiple líneas

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
"!"              return 'NOT';
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


\"[^\"]*\"				{ yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
[0-9]+("."[0-9]+)?\b  	                return 'DECIMAL';
[0-9]+\b				return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]*	                return 'ID';
\'.\'                                   return 'CARACTER';
        


<<EOF>>				return 'EOF';
.					{ console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }

/lex


%{
        const TIPO_INSTRUCCION	    = require('./instrucciones').TIPO_INSTRUCCION;
	const OBJETO_INSTRUCCION    = require('./instrucciones').OBJETO_INSTRUCCION;
%}
%left 'AND' 'OR' 
%left 'IGUALIGUAL' 'DIFERENTE' 
%left 'MAYOR' 'MENOR' ' MAYORIGUAL' 'MENORIGUAL'
%left 'MAS' 'MENOS'
%left 'MULTIPLICACION' 'DIVISION'
%left 'UMENOS'


/* Asociación de operadores y precedencia */

%start ini

%% /* Definición de la gramática */

ini
	: instrucciones EOF  {return $1;} 
;

instrucciones 
        :   instrucciones instruccion {$1.push($2); $$ = $1;  }
        |   instruccion { $$ = [$1]; }
;

instruccion 
        :   declaracion {$$= $1;}
        |   asignacion  {$$=  $1;}
        |   main        {$$=  $1;}
        |   metodo      {$$=  $1;}
        |   funcion     {$$=  $1;}
;

declaracion 
        :   tipo declaraciones PYCOMA {$$ = OBJETO_INSTRUCCION.Declaracion($1,$2);}
;

declaraciones 
        :   declaraciones COMA decla { $1.push($3); $$ = $1;}
        |   decla                    {$$ = [$1];} 
;

 decla  
        :   ID IGUAL operacion   {$$ = $1+$2+$3;}
        |   ID                   {$$ = $1+"= 0";}
;
 
main    
        :   VOID MAIN PARIZQ PARDER LLAVEIZQ sentencias LLAVEDER {}
;

metodo 
        :   VOID ID PARIZQ PARDER LLAVEIZQ sentencias LLAVEDER  {} 
        |   VOID ID PARIZQ parametros PARDER LLAVEIZQ sentencias LLAVEDER  {}
;

parametros 
        :   parametros COMA parametro {$1.push($3); $$ = $1;}
        |   parametro                 {$$ = [$1]; }
;

parametro  
        :   tipo ID {$$=  $1}
;

funcion 
        :   tipo ID PARIZQ PARDER LLAVEIZQ sentencias LLAVEDER  {}
        |   tipo ID PARIZQ parametros PARDER LLAVEIZQ sentencias LLAVEDER  {}
;   

sentencias
        :   sentencias sentencia {$1.push($2); $$ = $1;}
        |   sentencia            {$$ = [$1];}
;

Sentencia 
        :   declaracion   {$$=  $1;}
        |   asignacion    {$$=  $1;}
        |   if            {$$=  $1;}
        |   while         {$$=  $1;}
        |   for           {$$=  $1;}
        |   do_while      {$$=  $1;}
        |   switch        {$$=  $1;}
        |   break         {$$=  $1;}
        |   return        {$$=  $1;}
        |   continue      {$$=  $1;}
        |   print         {$$=  $1;} 
        |   callMetodo    {$$=  $1;}
;

asignacion 
        :   ID IGUAL operacion PYCOMA {$$ = TIPO_INSTRUCCION.Asignacion($1,$3);}
;

if 
        :   IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER       {$$ = TIPO_INSTRUCCION.s_If($3,$6);}
        |   IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER ELSE LLAVEIZQ sentencias LLAVEDER {$$ = TIPO_INSTRUCCION.s_Else($3,$6,$10);}
        |   IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER else_if          {$$ = TIPO_INSTRUCCION.s_Ifaux($3,$6,"",$8);}
        |   IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER else_if ELSE LLAVEIZQ sentencias LLAVEDER {$$ = TIPO_INSTRUCCION.s_Ifaux($3,$6,$11,$8);}}
;

else_if 
        :   else_if elif            {$1.push($2); $$ = $1;}
        |   elif                    {$$ = [$1];}
;

elif 
        :   ELSE IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER   {$$= TIPO_INSTRUCCION.s_Elif($3,$6);}
;

while 
        :   WHILE PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER  {$$ = TIPO_INSTRUCCION.s_While($3,$6);}
;

do_while 
        :   DO LLAVEIZQ sentencias LLAVEDER WHILE PARIZQ operacion PARDER PYCOMA  {$$ = TIPO_INSTRUCCION.s_DO($3,$7);}
;

for 
        :   FOR PARIZQ inicializacion PYCOMA operacion PYCOMA incremento PARDER LLAVEIZQ sentencias LLAVEDER  {$$=TIPO_INSTRUCCION.s_For($3,$5,$7,$10);}
;

inicializacion 
        :   tipo ID IGUAL operacion  {$$= $4;}
        |   ID IGUAL operacion   {$$ = $4;}
;

incremento 
        :   ID MAS MAS   {$$= $1;}
        |   ID MENOS MENOS  {$$ = $1;}
;

callMetodo 
        :   ID PARIZQ PARDER PYCOMA  {}
        |   ID PARIZQ valores PARDER PYCOMA   {}
;

print 
        :   CONSOLE PUNTO WRITE PARIZQ CADENA COMA valores PARDER PYCOMA  {}
        |   CONSOLE PUNTO WRITE PARIZQ CADENA MAS valores PARDER PYCOMA   {}
        |   CONSOLE PUNTO WRITE PARIZQ CADENA PARDER PYCOMA               {}
        |   CONSOLE PUNTO WRITE PARIZQ CSIMPLE valores CSIMPLE PARDER PYCOMA   {}
;

valores 
        :   valores COMA operacion  {$1.push($2); $$ = $1;}
        |   operacion               {$$ = $1;}
;

switch 
        :   SWITCH PARIZQ operacion PARDER LLAVEIZQ casos LLAVEDER   {}
;

casos 
        :   casos caso                  {$1.push($2); $$ = $1;}
        |   caso                        {$$ = [$1];}
;

caso 
        :   CASE operacion DOSPUNTOS sentencias   {}
        |   DEFAULT DOSPUNTOS sentencias          {}
;

break 
        :   BREAK PYCOMA                          {}
;

continue 
        : CONTINUE PYCOMA                         {}
;

return 
        :   RETURN operacion PYCOMA               {}
        |   RETURN PYCOMA                         {}
;

operacion 
        :       operacion AND operacion
        |       operacion OR operacion
        |       NOT operacion %prec UMENOS
        |       operacion_relacional
        ;

operacion_relacional
        :       operacion_numerica   IGUALIGUAL      operacion_numerica                {}
        |       operacion_numerica   DIFERENTE       operacion_numerica                {}
        |       operacion_numerica   MAYOR           operacion_numerica                {}
        |       operacion_numerica   MENOR           operacion_numerica                {}
        |       operacion_numerica   MAYORIGUAL      operacion_numerica                {}
        |       operacion_numerica   MENORIGUAL      operacion_numerica                {}
        |       operacion_numerica
        ;

operacion_numerica 
        :   operacion_numerica   MAS             operacion_numerica                {}
        |   operacion_numerica   MENOS           operacion_numerica                {}
        |   operacion_numerica   MULTIPLICACION  operacion_numerica                {}
        |   operacion_numerica   DIVISION        operacion_numerica                {}
        |       MENOS operacion_numerica %prec UMENOS    {}
        |       PARIZQ operacion PARDER
        |       ID PARIZQ PARDER
        |       ID PARIZQ valores PARDER
        |   valor                {}
;

tipo 
        :   INT                 {$$ = $1;}
        |   DOUBLE              {}
        |   CHAR                {}
        |   ID                  {}
        |   STRING              {}
;    

valor 
        :   ENTERO               {} 
        |   ID                   {}
        |   DECIMAL              {}
        |   CARACTER             {}   
        |   CADENA               {}  
        |   FALSE                {}
        |   TRUE                 {}
;
