const { main } = require("./gramatica");

const TIPO_INSTRUCCION = {
  Declaracion : 'TIPO_DECLARACION',
  Asignacion : 'TIPO_ASIGNACION',
  s_If: 'TIPO_IF',
  s_For: 'TIPO_FOR',
  s_While: 'TIPO_WHILE',
  s_Switch:  'TIPO_SWITCH',
  s_Do:   'TIPO_DOWHILE',
  s_Break: 'TIPO_BREAK',
  s_Return: 'TIPO_RETURN',
  s_Continue: 'TIPO_CONTINUE',
  s_CallMetodo: 'TIPO_LLAMADA',
  i_Main :  'TIPO_MAIN',
  i_Metodo : 'TIPO_METODO',
  i_Funcion : 'TIPO_FUNCION',
  s_Else:  'TIPO_ELSE',
  s_Elif: 'TIPO_ELIF',
  s_Ifaux: 'TIPO_IFELIF',
  s_Print: 'TIPO_PRINT'
}

const OBJETO_INSTRUCCION = {
  Declaracion: function(tipo,declaraciones){
    var salida = "";
    declaraciones.forEach(declaracion => {
      salida = salida + declaracion +"\n";
    });
    return {etiqueta: TIPO_INSTRUCCION.TIPO_DECLARACION, valor: salida}
  },
  Asignacion: function(identificador, operacion){
    var salida = "";
    salida = identificador + operacion;
    return {etiqueta: TIPO_INSTRUCCION.TIPO_ASIGNACION, valor: salida}
  },
  s_If: function(condiciones,sentencias,){
    return {etiqueta: TIPO_INSTRUCCION.TIPO_IF, condicion:condiciones, sentencia:sentencias}
  },

  s_Else: function(condicionI,sentenciasI,sentencias){
    return {etiqueta: TIPO_INSTRUCCION.TIPO_ELSE,condicion:condicionI,sentencias:sentenciasI, sentencia:sentencias}
  },
  s_Elif: function(condiciones,sentencias){
    return {etiqueta: TIPO_INSTRUCCION.TIPO_ELIF,condicion:condiciones, sentencia:sentencias}
  },
  s_Ifaux: function(condiciones,sentencias,sentenciasE,elif){
    return{etiqueta: TIPO_INSTRUCCION.TIPO_IFELIF,condicion:condiciones,sentencia:sentencias,sentenciaE:sentenciasE,elseif:elif}
  },
  s_while: function(condiciones,sentencias){
      return{etiqueta: TIPO_INSTRUCCION.TIPO_WHILE, condicion:condiciones, sentencia:sentencias}
  },
  s_Do: function(sentencias,condiciones){
    return{etiqueta: TIPO_INSTRUCCION.TIPO_DOWHILE, condicion:condiciones, sentencia:sentencias}
  },
  s_For: function(inicial,condiciones,variables,sentencias){
    return{etiqueta: TIPO_INSTRUCCION.TIPO_FOR,inicializacion: inicial, condicion:condiciones, variable:variables,sentencia:sentencias}
  }
}



module.exports.TIPO_INSTRUCCION = TIPO_INSTRUCCION;
module.exports.OBJETO_INSTRUCCION = OBJETO_INSTRUCCION;