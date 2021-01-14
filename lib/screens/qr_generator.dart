import 'package:flutter/material.dart';
import 'package:flutterapp/llista_items_usuari.dart';
import 'package:flutterapp/widgets/templatepage.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Generate extends StatefulWidget {
  final String id;
  Generate({this.id});
  @override
  _GenerateState createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  //Modificar aquest string per canviar el destí del QR.
  //En el nostre cas, aquí ha d'anar la ID que es genere segons el QR.
  //En cas de que la varibale no es mantengui en memoria fins que acabi la gestió
  //Toaca afegir una consulta al Firebase. Pero penso que es millor mantenir la ID.

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //S'assigna la data recollida anteriorment (ID en el nostre cas) al QR
              //També es genera la imatge en base al qrData aportat.
              QrImage(data: widget.id),

              //Creem els textos i caixa que acompañen al QR
              //Realment aquest SizedBox es prescindible.
              SizedBox(height: 10.0),
              Text(
                  "Aquest es el QR de la teva sessió. \n Comparteix aquest QR amb tots el que hi participin."),
              SizedBox(
                height: 10.0,
              ),

              //Porta a la pàgina llista items usuari
              FlatButton(
                padding: EdgeInsets.all(15.0),
                child: Text("CONTINUAR"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LlistaItemsUsuari(),
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.blue, width: 3.0),
                ),
              )
            ]),
      ),
    );
  }

  final qrText = TextEditingController();
}
