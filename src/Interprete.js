var parser = require('./gramatica');
var fs = require('fs');
var himalaya = require('himalaya');
const { Console } = require('console');
const OBJETO_INSTRUCCION = require('./instrucciones').OBJETO_INSTRUCCION;
const TIPO_INSTRUCCION = require('./instrucciones').TIPO_INSTRUCCION;
let ast;
var html = "";
var traduccion = "";
var simbolos = [];
var valor = [];
var contador = 0;
var trahtml;
class interprete {

    constructor() {
    }
    Parser(data) {
        try {
            simbolos[0] ="";
            valor[0] ="";
            ast = parser.parse(data.toString());
            this.procesarBloque(ast, 0);
            fs.writeFileSync('./ast.json', JSON.stringify(ast, null, 2));
            console.log("traduccion a Phyton");
            console.log(traduccion);
            console.log("html");
            console.log(html);
            console.log("simbolos");
            for (let index = 0; index < simbolos.length; index++) {
                const element = simbolos[index];
                const val = valor[index];
                console.log(element + " " + val);
            }
            console.log("json");
            this.convertir(html);
            return { phyton: traduccion, htm: html, sim: simbolos, valo: valor, jss: trahtml };
        } catch (e) {
            console.error(e);
            return "FALLO";
        }
    }
    convertir(html) {
        var json = himalaya.parse(html);
        trahtml = JSON.stringify(json);
         console.dir(json, { colors: true, depth: null });
    }
    procesarBloque(instrucciones, indice) {
        instrucciones.forEach(instruccion => {
            if (instruccion.etiqueta == 3) { this.procesarMain(instruccion, indice); }
            else if (instruccion.etiqueta == 1) { this.procesarDeclaracion(instruccion, indice); }
            else if (instruccion.etiqueta == 2) { this.procesarAsignacion(instruccion, indice); }
            else if (instruccion.etiqueta == 6) { this.procesarIf(instruccion, indice); }
            else if (instruccion.etiqueta == 7) { this.procesarElse(instruccion, indice); }
            else if (instruccion.etiqueta == 8) { this.procesarElif(instruccion, indice); }
            else if (instruccion.etiqueta == 9) { this.procesarIfelif(instruccion, indice); }
            else if (instruccion.etiqueta == 12) { this.procesarFor(instruccion, indice); }
            else if (instruccion.etiqueta == 10) { this.procesarWhile(instruccion, indice); }
            else if (instruccion.etiqueta == 11) { this.procesarDoWhile(instruccion, indice); }
            else if (instruccion.etiqueta == 16) { this.procesarSwitch(instruccion, indice); }
            else if (instruccion.etiqueta == 17) { this.procesarCaso(instruccion, indice); }
            else if (instruccion.etiqueta == 18) { this.procesarDefault(instruccion, indice); }
            else if (instruccion.etiqueta == 14) { this.procesarPrint(instruccion, indice); }
            else if (instruccion.etiqueta == 15) { this.procesarPrintHtml(instruccion, indice); }
            else if (instruccion.etiqueta == 19) { this.procesarBreak(instruccion, indice); }
            else if (instruccion.etiqueta == 21) { this.procesarContinue(instruccion, indice); }
            else if (instruccion.etiqueta == 20) { this.procesarReturn(instruccion, indice); }
            else if (instruccion.etiqueta == 13) { this.procesarCallmetodo(instruccion, indice); }
            else if (instruccion.etiqueta == 4) { this.procesarMetodo(instruccion, indice); }
            else if (instruccion.etiqueta == 5) { this.procesarFuncion(instruccion, indice); }
            else if (instruccion.etiqueta == 22) { this.procesarincremento(instruccion, indice); }
            else if (instruccion.etiqueta == 23) { this.procesarError(instruccion); }
            else { throw 'ERROR: tipo de instrucción no válido: ' + instruccion; }
        });
    }
    procesarError(instruccion) {
        console.log("Error: "+ instruccion.er+ " linea "+instruccion.fila + " columna " + instruccion.columna);
    }

    procesarDeclaracion(instruccion, indice) {
        traduccion += this.getTabulaciones(indice) + instruccion.valor + " " + '\n';
        //simbolos += "tipo = "+ instruccion.tip + " " +instruccion.valor + '\n';
        valor[contador] = instruccion.valor;
        simbolos[contador++] = instruccion.tip;

    }

    procesarAsignacion(instruccion, indice) {
        traduccion += this.getTabulaciones(indice) + instruccion.valor + " " + '\n';
        // simbolos += "tipo : var " + "variable: "+instruccion.id + " valor: "  +instruccion.op + '\n';
        valor[contador] = instruccion.id + " " + instruccion.op;
        simbolos[contador++] = "var";
    }

    procesarMain(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        traduccion += tabs + "def main():" + '\n';
        var instrucciones = instruccion.sentencia
        this.procesarBloque(instrucciones, indice + 1);
        traduccion += tabs + "if__name__= \"__main__\"" + '\n';
        traduccion += tabs + "   main()" + '\n';
    }
    procesarIf(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        traduccion += tabs + "if " + instruccion.condicion + " :" + '\n';
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones, indice + 1);
    }
    procesarElse(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        traduccion += tabs + "if " + instruccion.condicion + " :" + '\n';
        var instrucciones = instruccion.sentenciaI;
        this.procesarBloque(instrucciones, indice + 1);
        traduccion += tabs + "else :" + '\n';
        var instruccionesE = instruccion.sentencia
        this.procesarBloque(instruccionesE, indice + 1);
    }
    procesarElif(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        traduccion += tabs + "elif " + instruccion.condicion + " :" + '\n';
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones, indice + 1);
    }
    procesarIfelif(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        traduccion += tabs + "if " + instruccion.condicion + " :" + '\n';
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones, indice + 1);
        var sentenciasEl = instruccion.elseif;
        this.procesarBloque(sentenciasEl, indice);
        if (instruccion.sentenciaE != "") {
            traduccion += tabs + "else :" + '\n';
            var instruccionesE = instruccion.sentenciaE
            this.procesarBloque(instruccionesE, indice + 1);
        }
    }
    procesarWhile(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        traduccion += tabs + "while " + instruccion.condicion + " :" + '\n';
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones, indice + 1);
    }
    procesarDoWhile(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        traduccion += tabs + "while True  :" + '\n';
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones, indice + 1);
        traduccion += tabs + "if (" + instruccion.condicion + "):" + '\n';
        traduccion += this.getTabulaciones(indice + 2) + "break" + '\n';
    }
    procesarFor(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        var inicial = parseInt(instruccion.inicializacion) + 1;
        traduccion += tabs + "for " + instruccion.variable + " in range(" + inicial + "," + instruccion.condicion + "):" + '\n';
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones, indice + 1);
    }
    procesarPrint(instruccion, indice) {
        traduccion += this.getTabulaciones(indice) + instruccion.valor + '\n';
    }
    procesarPrintHtml(instruccion, indice) {
        traduccion += this.getTabulaciones(indice) + instruccion.valor + '\n';
        html = html + instruccion.val + '\n';
    }
    procesarFuncion(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        traduccion += tabs + "def " + instruccion.id + " (" + instruccion.parametro + "):" + '\n';
        var instrucciones = instruccion.sentencia
        this.procesarBloque(instrucciones, indice + 1);
    }
    procesarMetodo(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        traduccion += tabs + "def " + instruccion.id + " (" + instruccion.parametro + "):" + '\n';
        var instrucciones = instruccion.sentencia
        this.procesarBloque(instrucciones, indice + 1);
    }
    procesarSwitch(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        traduccion += tabs + "def switch(case," + instruccion.condicion + ")  :" + '\n';
        traduccion += tabs + "   switcher = {" + '\n';
        var casos = instruccion.caso;
        this.procesarBloque(casos, indice + 1);
        traduccion += tabs + "   }" + '\n';
    }
    procesarCaso(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        var instrucciones = instruccion.sentencia;
        traduccion += tabs + instruccion.valor + ":" + '\n';
        this.procesarBloque(instrucciones, indice);
    }
    procesarDefault(instruccion, indice) {
        var tabs = this.getTabulaciones(indice);
        traduccion += tabs + "default: " + '\n';
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones, indice);
    }
    procesarBreak(instruccion, indice) {
        traduccion += this.getTabulaciones(indice) + instruccion.valor + '\n';

    }
    procesarContinue(instruccion, indice) {
        traduccion += this.getTabulaciones(indice) + instruccion.valor + '\n';

    }
    procesarReturn(instruccion, indice) {
        traduccion += this.getTabulaciones(indice) + instruccion.valor + '\n';
    }
    procesarCallmetodo(instruccion, indice) {
        traduccion += this.getTabulaciones(indice) + instruccion.valor + '\n';
    }
    procesarincremento(instruccion, indice) {
        traduccion += this.getTabulaciones(indice) + instruccion.valor + '\n';
    }
    getTabulaciones(indice) {
        var salida = "";
        for (var i = 0; i <= indice; i++) {
            salida = salida + "  ";
        }
        return salida;
    }
}

module.exports = interprete;