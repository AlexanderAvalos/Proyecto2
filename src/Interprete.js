var parser = require('./gramatica');
const OBJETO_INSTRUCCION    = require('./instrucciones').OBJETO_INSTRUCCION;
const TIPO_INSTRUCCION	    = require('./instrucciones').TIPO_INSTRUCCION;
let ast;

class interprete{

    constructor(){
        this.index = 0;
    }
     Parser(data){
        try{
            console.log(data.toString());
            ast = parser.parse(data.toString(),0);
            this.procesarBloque(ast);
            return "exito";
        }catch(e){
            console.error(e);
            return "FALLO";
        }
    }
    
    procesarBloque(instrucciones, indice) {
        instrucciones.forEach(instruccion => {
            if(instruccion.etiqueta === TIPO_INSTRUCCION.TIPO_DECLARACION) this.procesarDeclaracion(instruccion, indice);
            else throw 'ERROR: tipo de instrucción no válido: ' + instruccion;
        });
    }
    procesarDeclaracion(instruccion, indice){
        console.log(this.getTabulaciones(indice)+instruccion.valor)

    }
    procesarMain(instruccion, indice){
        var tabs = this.getTabulaciones(indice)
        instrucciones = instruccion.instrucciones
        //this,procesarBloque(instrucciones, indice+1)

    }
    getTabulaciones(indice){
        var salida = "";
        for (var i = 0; i<indice; i++){
            salida = salida+ "  ";
        }
        return salida;
    }
}

module.exports = interprete;