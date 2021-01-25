import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/qr_generator.dart';
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
  List<Comanda> _comanda =
      []; //Aquesta es la llista de items que forma la comanda
  TextEditingController _editaNom;
  TextEditingController _editaPreu;
  TextEditingController _editaQuant;

  @override
  void initState() {
    _comanda = [];
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

  Widget _buildError(error) {
    return Center(
      child: Text(
        error.toString(),
        style: TextStyle(
          color: Colors.blue,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _confirmaEsborrarItem(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmació'),
        content: Text(
          "Estàs segur que vols esborrar l'ítem '${_comanda[index].nom}'",
        ),
        actions: [
          FlatButton(
            child: Text('Cancel·la'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text('Esborra'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    ).then((esborra) {
      if (esborra) {
        setState(() {
          _comanda.removeAt(index);
        });
      }
    });
  }

  String _confirmarComanda() {
    final comandes = FirebaseFirestore.instance.collection('comandes');
    final comandaref = comandes.doc();
    final comandaID = comandaref.id;
    final users = comandaref.collection('usuaris').doc("userID");
    final items = comandaref.collection('items');

    final batch = FirebaseFirestore.instance.batch();
    for (var item in _comanda) {
      batch.set(items.doc(), {
        "nom": item.nom,
        "preu": item.preu,
        "quantitat": item.quantitat,
      });
    }
    batch.set(users, {
      "idUsuari": FirebaseAuth.instance.currentUser.uid,
      'nomUsuari': FirebaseAuth.instance.currentUser.email,
    });
    batch.commit();

    print(comandaID);
    return comandaref.id;
  }

  double _calculaTotal() {
    if (_comanda.isEmpty) {
      return 0.00;
    } else {
      return _comanda.map((i) => i.preu * i.quantitat).reduce((a, b) => a + b);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      body: Column(
        children: [
          Padding(
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
                    setState(() {
                      _comanda.add(
                        Comanda(
                          _editaNom.text,
                          double.parse(_editaPreu.text),
                          int.parse(_editaQuant.text),
                        ),
                      );
                      _editaNom.clear();
                      _editaPreu.clear();
                      _editaQuant.clear();
                    });
                  },
                  color: Colors.teal,
                  child: Text(
                    "Afegir a la comanda",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.teal)),
                ),

/***************************************************************************/

                RaisedButton(
                  //Aqui es passa a la seguent pantalla i la llista s'afegeix a firebase
                  onPressed: _comanda.isEmpty
                      ? null
                      : () {
                          var comandaID = _confirmarComanda();
                          final userID = FirebaseFirestore.instance
                              .collection('comandes/${comandaID}/usuaris')
                              .doc("userID")
                              .id;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Generate(
                                id: comandaID,
                                comandaUsuari: userID,
                              ),
                            ),
                          );
                        },
                  color: Colors.green,

                  child: Text(
                    "Confirmar comanda",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green)),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.teal),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                    itemCount: _comanda.length,
                    itemBuilder: (context, index) {
                      final item = _comanda[index];
                      return ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _confirmaEsborrarItem(index),
                        ),
                        title: Row(
                          children: [
                            Text(
                              item.nom,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Preu: ${(item.preu * item.quantitat).toStringAsFixed(2)}€",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          "Quantitat: ${item.quantitat}",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[800],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Total: ${_calculaTotal().toString()}€",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
