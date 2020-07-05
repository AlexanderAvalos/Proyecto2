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


"&&"             return 'AND';
"||"             return 'OR';
"!="             return 'DIFERENTE';
"=="             return 'IGUALIGUAL';
">="             return 'MAYORIGUAL';
"<="             return 'MENORIGUAL';
"!"              return 'NOT';
":"              return 'DOSPUNTOS';
";"              return 'PYCOMA';
","              return 'COMA';
"\'"             return 'CSIMPLE';
"="              return 'IGUAL';
"}"              return 'LLAVEDER';
"{"              return 'LLAVEIZQ';
"("              return 'PARIZQ';
")"              return 'PARDER';
">"              return 'MAYOR';
"<"              return 'MENOR';
//SIGNOS
"."              return 'PUNTO';
"+"              return 'MAS';
"-"              return 'MENOS';
"/"              return 'DIVISION';
"*"              return 'MULTIPLICACION';
//ESPACIOS EN BLANCO
\'[^\']\'                               return 'CARACTER';
\'[^\']*\'                              return 'CADENAHTML';
\"[^\"]*\"				{ yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }
[0-9]+("."[0-9]+)?\b  	                return 'DECIMAL';
[0-9]+\b				return 'ENTERO'
([a-zA-Z])[a-zA-Z0-9_]*	                return 'ID';

        


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
        :   declaracion {$$=  $1;}
        |   asignacion  {$$=  $1;}
        |   main1        {$$=  $1;}
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
 
main1   
        :   VOID MAIN PARIZQ PARDER LLAVEIZQ sentencias LLAVEDER {$$ = OBJETO_INSTRUCCION.i_Main($6);}
;

metodo 
        :   VOID ID PARIZQ PARDER LLAVEIZQ sentencias LLAVEDER  {$$ = OBJETO_INSTRUCCION.i_Metodo($2,"",$6);} 
        |   VOID ID PARIZQ parametros PARDER LLAVEIZQ sentencias LLAVEDER  {$$ = OBJETO_INSTRUCCION.i_Metodo($2,$4,$7);}
;

parametros 
        :   parametros COMA parametro {$1.push($3); $$ = $1;}
        |   parametro                 {$$ = [$1]; }
;

parametro  
        :   tipo ID {$$=  $2}
;

funcion 
        :   tipo ID PARIZQ PARDER LLAVEIZQ sentencias LLAVEDER  {$$ = OBJETO_INSTRUCCION.i_Funcion($2,"",$6);}
        |   tipo ID PARIZQ parametros PARDER LLAVEIZQ sentencias LLAVEDER  {$$ = OBJETO_INSTRUCCION.i_Funcion($2,$4,$7);}
;   

sentencias
        :   sentencias sentencia {$1.push($2); $$ = $1;}
        |   sentencia            {$$ = [$1];}
;

sentencia 
        :   declaracion   {$$=  $1;}
        |   callMetodo    {$$=  $1;}
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
;

asignacion 
        :   ID IGUAL operacion PYCOMA {$$ = OBJETO_INSTRUCCION.Asignacion($1+$2,$3);}
;

if 
        :   IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER       {$$ = OBJETO_INSTRUCCION.s_If($3,$6);}
        |   IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER ELSE LLAVEIZQ sentencias LLAVEDER {$$ = OBJETO_INSTRUCCION.s_Else($3,$6,$10);}
        |   IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER else_if          {$$ = OBJETO_INSTRUCCION.s_Ifaux($3,$6,"",$8);}
        |   IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER else_if ELSE LLAVEIZQ sentencias LLAVEDER {$$ = OBJETO_INSTRUCCION.s_Ifaux($3,$6,$11,$8);}}
;

else_if 
        :   else_if elif            {$1.push($2); $$ = $1;}
        |   elif                    {$$ = [$1];}
;

elif 
        :   ELSE IF PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER   {$$= OBJETO_INSTRUCCION.s_Elif($4,$7);}
;

while 
        :   WHILE PARIZQ operacion PARDER LLAVEIZQ sentencias LLAVEDER  {$$ = OBJETO_INSTRUCCION.s_while($3,$6);}
;

do_while 
        :   DO LLAVEIZQ sentencias LLAVEDER WHILE PARIZQ operacion PARDER PYCOMA  {$$ = OBJETO_INSTRUCCION.s_Do($3,$7);}
;

for 
        :   FOR PARIZQ inicializacion PYCOMA operacion PYCOMA incremento PARDER LLAVEIZQ sentencias LLAVEDER  {$$=OBJETO_INSTRUCCION.s_For($3,$5,$7,$10);}
;

inicializacion 
        :   tipo ID IGUAL operacion  {$$= $4;}
        |   ID IGUAL operacion   {$$ = $3;}
;

incremento 
        :   ID MAS MAS   {$$ =  $1;}
        |   ID MENOS MENOS  {$$ = $1;}
;

callMetodo 
        :   ID PARIZQ PARDER PYCOMA  {$$=OBJETO_INSTRUCCION.s_CallMetodo($1,"");}
        |   ID PARIZQ valores PARDER PYCOMA   {$$=OBJETO_INSTRUCCION.s_CallMetodo($1,$3);}
        |   incremento PYCOMA  {$$ = OBJETO_INSTRUCCION.s_incremento( $1 + "+= 1");}

;

print 
        :   CONSOLE PUNTO WRITE PARIZQ CADENA COMA valores PARDER PYCOMA  {$$ = OBJETO_INSTRUCCION.s_Print('\"'+$5+'\"'+$6+$7);}
        |   CONSOLE PUNTO WRITE PARIZQ CADENA MAS valores PARDER PYCOMA   {$$ = OBJETO_INSTRUCCION.s_Print('\"'+$5+'\"'+","+$7);}
        |   CONSOLE PUNTO WRITE PARIZQ valor PARDER PYCOMA                {$$ = OBJETO_INSTRUCCION.s_Print($5);}
        |   CONSOLE PUNTO WRITE PARIZQ CADENAHTML PARDER PYCOMA           {$$ = OBJETO_INSTRUCCION.s_PrintH($5);}
;

valores 
        :   valores COMA operacion  {$1.push($3); $$ = $1;}
        |   operacion               {$$ = [$1];}
;

switch 
        :   SWITCH PARIZQ operacion PARDER LLAVEIZQ casos LLAVEDER   {$$= OBJETO_INSTRUCCION.s_Switch($3,$6);}
;

casos 
        :   casos caso                  {$1.push($2); $$ = $1;}
        |   caso                        {$$ = [$1];}
;

caso 
        :   CASE operacion DOSPUNTOS sentencias   {$$ = OBJETO_INSTRUCCION.s_Casos($2,$4);}
        |   DEFAULT DOSPUNTOS sentencias          {$$ = OBJETO_INSTRUCCION.s_Default($3);}
;

break 
        :   BREAK PYCOMA                          {$$ = OBJETO_INSTRUCCION.s_Break();}
;

continue 
        : CONTINUE PYCOMA                         {$$ = OBJETO_INSTRUCCION.s_Continue();}
;

return 
        :   RETURN operacion PYCOMA               {$$ = OBJETO_INSTRUCCION.s_Return($2);}
        |   RETURN PYCOMA                         {$$ = OBJETO_INSTRUCCION.s_Return("");}
;

operacion 
        :       operacion AND operacion           {$$ = $1 + "and" + $3;}
        |       operacion OR operacion            {$$ = $1 + "or" + $3;}
        |       NOT operacion %prec UMENOS        {$$ =  "not" + $2;}
        |       operacion_relacional              {$$ = $1;}
;

operacion_relacional
        :       operacion_numerica   IGUALIGUAL      operacion_numerica                {$$ = $1 + "==" + $3;}
        |       operacion_numerica   DIFERENTE       operacion_numerica                {$$ = $1 + "!=" + $3;}
        |       operacion_numerica   MAYOR           operacion_numerica                {$$ = $1 + ">" + $3;}
        |       operacion_numerica   MENOR           operacion_numerica                {$$ = $1 + "<" + $3;}
        |       operacion_numerica   MAYORIGUAL      operacion_numerica                {$$ = $1 + ">=" + $3;}
        |       operacion_numerica   MENORIGUAL      operacion_numerica                {$$ = $1 + "<=" + $3;}
        |       operacion_numerica                                                     {$$ = $1;}
        ;

operacion_numerica 
        :   operacion_numerica   MAS             operacion_numerica                {$$ = $1 + "+" + $3;}
        |   operacion_numerica   MENOS           operacion_numerica                {$$ = $1 + "-" + $3;}
        |   operacion_numerica   MULTIPLICACION  operacion_numerica                {$$ = $1 + "*" + $3;}
        |   operacion_numerica   DIVISION        operacion_numerica                {$$ = $1 + "/" + $3;}
        |   MENOS operacion_numerica %prec UMENOS    {$$ = "-" +$2;}
        |   PARIZQ operacion PARDER                  {$$ = "("+$2+")";}
        |   ID PARIZQ PARDER                         {$$ = $1+"()" ;}
        |   ID PARIZQ valores PARDER                 {$$ = $1+"("+$3+")";}
        |   valor                {$$ = $1;}
;

tipo 
        :   INT                 {$$ = $1;}
        |   DOUBLE              {$$ = $1;}
        |   CHAR                {$$ = $1;}
        |   ID                  {$$ = $1;}
        |   STRING              {$$ = $1;}
;    

valor 
        :   ENTERO               {$$ = $1;} 
        |   ID                   {$$ = $1;}
        |   DECIMAL              {$$ = $1;}
        |   CARACTER             {$$ = $1;}   
        |   CADENA               {$$ = '\"'+$1+'\"';}  
        |   FALSE                {$$ = $1;}
        |   TRUE                 {$$ = $1;}
;
