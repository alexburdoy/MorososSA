import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/templatepage.dart';

import 'llista.dart';

class Resultat {
  Comanda list;
  Resultat({this.list});
}

class IntroItem extends StatefulWidget {
  final Comanda l;
  IntroItem({this.l});
  @override
  _IntroItemState createState() => _IntroItemState();
}

class _IntroItemState extends State<IntroItem> {
  List<Comanda> comanda; //Aquesta es la llista de items que forma la comanda
  TextEditingController _editaNom;
  TextEditingController _editaPreu;
  TextEditingController _editaQuant;

  @override
  void initState() {
    _editaNom = TextEditingController();
    _editaPreu = TextEditingController();
    _editaQuant = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _editaNom.dispose();
    _editaPreu.dispose();
    _editaQuant.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              //Els 3 seguents son els textfields de les 3 opcions a omplir
              controller: _editaNom,
              decoration: InputDecoration(labelText: 'Nom: '),
            ),
            TextField(
              controller: _editaPreu,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Preu: '),
            ),
            TextField(
              controller: _editaQuant,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Quantitat: '),
            ),

/***************************************************************************/

            RaisedButton(
              //Al apretar el botó ho afegeix a una llista
              onPressed: () {
                comanda.add(
                  Comanda(_editaNom.text, _editaPreu.text, _editaQuant.text),
                );
              },
              color: Colors.red,
              child: Text(
                "Afegir a la comanda",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),
            ),

/***************************************************************************/

            RaisedButton(
              //Aqui es passa a la seguent pantalla i la llista s'afegeix a firebase
              onPressed: () {},
              color: Colors.red,
              child: Text(
                "Confirmar comanda",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),
            ),
            /* if (comanda.length>0){
              ListView.builder(
              itemCount: comanda.length,
              itemBuilder: (context,index){
                final com = comanda[index];
                return ListTile(
                  title: Text(com.nom),
                );
              }
            )
            }*/
          ],
        ),
      ),
    );
  }

  void _confirmarComanda() {}
}
