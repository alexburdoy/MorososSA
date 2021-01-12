/*
AQUESTA PÀGINA ES TOT UN HOME PER A AFEGIR BOTONS PER ESCANEJAR
I GENERAR EL QR. NO ES NECESARIA JA QUE ESTÁ EL MAIN.


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Scanpage extends StatefulWidget{
  @override
  _Scanpage createState() => _Scanpage();
}

class _Scanpage extends State<Scanpage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
      ),

      body: Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Assignem una imatge a la página del QR
              Image(image: NetworkImage(""))
          ],
        ),
      ),
    );
  }
  Widget flatButon(String text, Widget widget){
    return FlatButton(
      child: Text(text),
      onPressed: (){
         Navigator.of(context).push(MaterialPageRoute(builder: (context)  => widget));
      },

      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
    );
  }
}
*/