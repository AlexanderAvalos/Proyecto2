const express = require('express');
const app = express();
const path = require('path');
const interprete = require('./Interprete');
var fs = require('fs'); 

//configuracion
app.set('port',3000)
app.set('views', path.join(__dirname,'Interfaz'));
app.engine('html', require('ejs').renderFile);
app.set('view engine', 'ejs');

// rutas
app.get('/', (req,res)=>{
    res.render('index.html');
});

app.get('/parser', (req,res)=>{
    const entrada = fs.readFileSync('./entrada.txt');
    var inter = new interprete();
    res.send(inter.Parser(entrada));
    console.log(inter.traduccion);
});


// escuchar
app.listen(app.get('port'),() => {
    console.log('servidor en puerto ', app.get('port'));
});