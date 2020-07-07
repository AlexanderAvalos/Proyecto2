const express = require('express');
const app = express();
const path = require('path');
const interprete = require('./Interprete');
var fs = require('fs');
const { get } = require('http');
const bodyParser = require('body-parser');
const body_parser = require('body-parser').json();

//configuracion
app.set('port', 3000)
app.set('views', path.join(__dirname, 'Interfaz'));
app.engine('html', require('ejs').renderFile);
app.set('view engine', 'ejs');
app.use(bodyParser.json());
app.use(function (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header('Access-Control-Allow-Methods', 'POST');
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With , Content-Type , Accept");
    next();
});
// rutas
app.get('/', (req, res) => {
    const entrada = fs.readFileSync('./entrada.txt');
    var inter = new interprete();
    var ope = inter.Parser(entrada);
    res.render('index.html', { traduccion: ope.phyton , htm: ope.htm, jss: ope.jss, entra:entrada});
});

// escuchar
app.listen(app.get('port'), () => {
    console.log('servidor en puerto ', app.get('port'));
});