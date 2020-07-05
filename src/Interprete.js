var parser = require('./gramatica');
var fs = require('fs'); 
var himalaya = require('himalaya');
const { Console } = require('console');
const OBJETO_INSTRUCCION    = require('./instrucciones').OBJETO_INSTRUCCION;
const TIPO_INSTRUCCION	    = require('./instrucciones').TIPO_INSTRUCCION;
let ast;
var  html="";
var  traduccion = "";
class interprete{

    constructor(){
    }
     Parser(data){
        try{
            console.log(data.toString());
            ast = parser.parse(data.toString());
            this.procesarBloque(ast,0);
            fs.writeFileSync('./ast.json', JSON.stringify(ast, null, 2));
            this.convertir(html);
            return "exito";
        }catch(e){
            console.error(e);
            return "FALLO";
        }
    }
    convertir(html){
        var json = himalaya.parse(html);
        console.dir(json,{colors: true,depth: null});
    }
    procesarBloque(instrucciones, indice) {
        instrucciones.forEach(instruccion => {
            if(instruccion.etiqueta == 3){this.procesarMain(instruccion,indice) ;}
            else if(instruccion.etiqueta == 1){this.procesarDeclaracion(instruccion, indice);}
            else if(instruccion.etiqueta == 2){this.procesarAsignacion(instruccion,indice);}
            else if(instruccion.etiqueta == 6){this.procesarIf(instruccion,indice);}
            else if(instruccion.etiqueta == 7){this.procesarElse(instruccion,indice);}
            else if(instruccion.etiqueta == 8){this.procesarElif(instruccion,indice);}
            else if(instruccion.etiqueta == 9){this.procesarIfelif(instruccion,indice);}
            else if(instruccion.etiqueta == 12){this.procesarFor(instruccion,indice);}
            else if(instruccion.etiqueta == 10){this.procesarWhile(instruccion,indice);}
            else if(instruccion.etiqueta == 11){this.procesarDoWhile(instruccion,indice);}
            else if(instruccion.etiqueta == 16){this.procesarSwitch(instruccion,indice);}
            else if(instruccion.etiqueta == 17){this.procesarCaso(instruccion,indice);}
            else if(instruccion.etiqueta == 18){this.procesarDefault(instruccion,indice);}
            else if(instruccion.etiqueta == 14){this.procesarPrint(instruccion,indice);}
            else if(instruccion.etiqueta == 15){this.procesarPrintHtml(instruccion,indice);}
            else if(instruccion.etiqueta == 19){this.procesarBreak(instruccion,indice);}
            else if(instruccion.etiqueta == 21){this.procesarContinue(instruccion,indice);}
            else if(instruccion.etiqueta == 20){this.procesarReturn(instruccion,indice);}
            else if(instruccion.etiqueta == 13){this.procesarCallmetodo(instruccion,indice);}
            else if(instruccion.etiqueta == 4){this.procesarMetodo(instruccion,indice);}
            else if(instruccion.etiqueta == 5){this.procesarFuncion(instruccion,indice);}
            else if(instruccion.etiqueta == 22){this.procesarincremento(instruccion,indice);}
            else {throw 'ERROR: tipo de instrucción no válido: ' + instruccion;}
        });
    }
    procesarDeclaracion(instruccion, indice){
        traduccion += this.getTabulaciones(indice)+instruccion.valor;
    }

    procesarAsignacion(instruccion, indice){
        traduccion +=this.getTabulaciones(indice)+instruccion.valor;
    }

    procesarMain(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        traduccion +=tabs+ "def main():";
        var instrucciones = instruccion.sentencia 
        this.procesarBloque(instrucciones, indice+1);
        traduccion +=tabs+"if__name__= \"__main__\"";
        traduccion +=tabs+"   main()";
    }
    procesarIf(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        traduccion +=tabs+ "if "+ instruccion.condicion + " :";
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones,indice+1);
    }
    procesarElse(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        traduccion +=tabs+ "if "+ instruccion.condicion + " :";
        var instrucciones = instruccion.sentenciaI;
        this.procesarBloque(instrucciones,indice+1);
        traduccion +=tabs+"else :";
        var instruccionesE = instruccion.sentencia
        this.procesarBloque(instruccionesE,indice+1);
    }
    procesarElif(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        traduccion +=tabs+ "elif "+ instruccion.condicion + " :";
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones,indice+1);
    }
    procesarIfelif(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        traduccion +=tabs+ "if "+ instruccion.condicion + " :";
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones,indice+1);
        var sentenciasEl = instruccion.elseif;
        this.procesarBloque(sentenciasEl,indice);
        if(instruccion.sentenciaE != ""){
            traduccion +=tabs+"else :";
            var instruccionesE = instruccion.sentenciaE
            this.procesarBloque(instruccionesE,indice+1);
        }
    }
    procesarWhile(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        traduccion +=tabs+ "while " + instruccion.condicion+ " :";
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones,indice+1);
    }
    procesarDoWhile(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        traduccion +=tabs+ "while True  :";
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones,indice+1);
        traduccion +=tabs+ "if ("+instruccion.condicion +"):";
        traduccion +=this.getTabulaciones(indice+2)+"break";
    }
    procesarFor(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        var inicial = parseInt(instruccion.inicializacion)+1;
        traduccion +=tabs+"for "+instruccion.variable +" in range("+inicial+","+instruccion.condicion+"):";
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones,indice+1);
    }
    procesarPrint(instruccion, indice){
        traduccion +=this.getTabulaciones(indice)+instruccion.valor;
    }
    procesarPrintHtml(instruccion, indice){
        traduccion +=this.getTabulaciones(indice)+instruccion.valor;
        html = html + instruccion.val+'\n';
    }
    procesarFuncion(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        traduccion +=tabs+ "def "+instruccion.id+" ("+instruccion.parametro+"):";
        var instrucciones = instruccion.sentencia 
        this.procesarBloque(instrucciones, indice+1);
    }
    procesarMetodo(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        traduccion +=tabs+ "def "+instruccion.id+" ("+instruccion.parametro+"):";
        var instrucciones = instruccion.sentencia 
        this.procesarBloque(instrucciones, indice+1);
    }
    procesarSwitch(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        traduccion +=tabs+ "def switch(case,"+instruccion.condicion+")  :";
        traduccion +=tabs+"   switcher = {";
        var casos = instruccion.caso;
        this.procesarBloque(casos,indice+1);
        traduccion +=tabs+"   }";
    }
    procesarCaso(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        var instrucciones = instruccion.sentencia;
        traduccion +=tabs+ instruccion.valor+":";
        this.procesarBloque(instrucciones,indice);
    }
    procesarDefault(instruccion, indice){
        var tabs = this.getTabulaciones(indice);
        traduccion +=tabs+"default: ";
        var instrucciones = instruccion.sentencia;
        this.procesarBloque(instrucciones,indice);
    }
    procesarBreak(instruccion, indice){
        traduccion +=this.getTabulaciones(indice)+instruccion.valor;

    }
    procesarContinue(instruccion, indice){
        traduccion +=this.getTabulaciones(indice)+instruccion.valor;

    }
    procesarReturn(instruccion, indice){
        traduccion +=this.getTabulaciones(indice)+instruccion.valor;
    }
    procesarCallmetodo(instruccion, indice){
        traduccion +=this.getTabulaciones(indice)+instruccion.valor;
    }
    procesarincremento(instruccion, indice){
        traduccion +=this.getTabulaciones(indice)+instruccion.valor;
    }
    getTabulaciones(indice){
        var salida = "";
        for (var i = 0; i<=indice; i++){
            salida = salida+ "  ";
        }
        return salida;
    }
}

module.exports = interprete;