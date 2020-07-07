const { main } = require("./gramatica");

const TIPO_INSTRUCCION = {
  Declaracion: 'TIPO_DECLARACION',
  Asignacion: 'TIPO_ASIGNACION',
  s_If: 'TIPO_IF',
  s_For: 'TIPO_FOR',
  s_While: 'TIPO_WHILE',
  s_Switch: 'TIPO_SWITCH',
  s_Do: 'TIPO_DOWHILE',
  s_Break: 'TIPO_BREAK',
  s_Return: 'TIPO_RETURN',
  s_Continue: 'TIPO_CONTINUE',
  s_CallMetodo: 'TIPO_LLAMADA',
  i_Main: 'TIPO_MAIN',
  i_Metodo: 'TIPO_METODO',
  i_Funcion: 'TIPO_FUNCION',
  s_Else: 'TIPO_ELSE',
  s_Elif: 'TIPO_ELIF',
  s_Ifaux: 'TIPO_IFELIF',
  s_Print: 'TIPO_PRINT',
  s_PrintH: 'TIPO_HTML',
  s_Casos: 'TIPO_CASO',
  s_Default: 'TIPO_DEFAULT',
  s_incremento: 'TIPO_INCREMENTO'
}

const OBJETO_INSTRUCCION = {
  Declaracion: function (tipo, declaraciones) {
    var salida = "";
    declaraciones.forEach(declaracion => {
      salida = salida + declaracion + " ";
    });
    return { etiqueta: 1, valor: salida, tip:tipo }
  },
  Asignacion: function (identificador, operacion) {
    var salida = "";
    salida = identificador + operacion + " ";
    return { etiqueta: 2, valor: salida , id:identificador, op:operacion}
  },
  i_Main: function (sentencias) {
    return { etiqueta: 3, sentencia: sentencias }
  },
  i_Metodo: function (identificador, parametros, sentencias) {
    return { etiqueta: 4, id: identificador, parametro: parametros, sentencia: sentencias }
  },
  i_Funcion: function (identificador, parametros, sentencias) {
    return { etiqueta: 5, id: identificador, parametro: parametros, sentencia: sentencias }
  },
  s_If: function (condiciones, sentencias) {
    return { etiqueta: 6, condicion: condiciones, sentencia: sentencias }
  },
  s_Else: function (condicionI, sentenciasI, sentencias) {
    return { etiqueta: 7, condicion: condicionI, sentenciaI: sentenciasI, sentencia: sentencias }
  },
  s_Elif: function (condiciones, sentencias) {
    return { etiqueta: 8, condicion: condiciones, sentencia: sentencias }
  },
  s_Ifaux: function (condiciones, sentencias, sentenciasE, elif) {
    return { etiqueta: 9, condicion: condiciones, sentencia: sentencias, sentenciaE: sentenciasE, elseif: elif }
  },
  s_while: function (condiciones, sentencias) {
    return { etiqueta: 10, condicion: condiciones, sentencia: sentencias }
  },
  s_Do: function (sentencias, condiciones) {
    return { etiqueta: 11, condicion: condiciones, sentencia: sentencias }
  },
  s_For: function (inicial, condiciones, variables, sentencias) {
    return { etiqueta: 12, inicializacion: inicial, condicion: condiciones, variable: variables, sentencia: sentencias }
  },
  s_CallMetodo: function (id, parametros) {
    var salida = id + '(' + parametros + ')';
    return { etiqueta: 13, valor: salida }
  },
  s_Print: function (valor) {
    var salida = "print(" + valor + ")";
    return { etiqueta: 14, valor: salida }
  },
  s_PrintH: function (valores) {
    var salida = "print(" + valores + ")";
    return { etiqueta: 15, valor: salida, val: valores }
  },
  s_Switch: function (condiciones, casos) {
    return { etiqueta: 16, condicion: condiciones, caso: casos }
  },
  s_Casos: function (valores, sentencias) {
    return { etiqueta: 17, valor: valores, sentencia: sentencias }
  },
  s_Default: function (sentencias) {
    return { etiqueta: 18, sentencia: sentencias }
  },
  s_Break: function () {
    var salida = "break";
    return { etiqueta: 19, valor: salida }
  },
  s_Return: function (operacion) {
    var salida = "return " + operacion;
    return { etiqueta: 20, valor: salida }
  },
  s_Continue: function () {
    var salida = "continue";
    return { etiqueta: 21, valor: salida }
  },
  s_incremento: function (id) {
    return { etiqueta: 22, valor: id }
  }
}



module.exports.TIPO_INSTRUCCION = TIPO_INSTRUCCION;
module.exports.OBJETO_INSTRUCCION = OBJETO_INSTRUCCION;