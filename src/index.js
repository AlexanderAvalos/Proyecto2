const express = require('express');
const app = express();
const path = require('path');

//configuracion
app.set('port',4000)
app.set('views', path.join(__dirname,'Interfaz'));
app.engine('html', require('ejs').renderFile);
app.set('view engine', 'ejs');

// rutas
app.get('/', (req,res)=>{
    res.render('index.html');
});

// escuchar
app.listen(app.get('port'),() => {
    console.log('servidor en puerto ', app.get('port'));
});