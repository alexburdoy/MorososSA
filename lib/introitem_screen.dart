import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Comanda> _comanda; //Aquesta es la llista de items que forma la comanda
  TextEditingController _editaNom;
  TextEditingController _editaPreu;
  TextEditingController _editaQuant;

  @override
  void initState() {
    _comanda = [
      Comanda("Olives", 2, 1),
    ];
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

  void _confirmarComanda(WriteBatch batch, itemsComanda) {
    for (var doc in docs) {
      batch.update(itemsComanda.doc(doc.id));
    }
    batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final itemsComanda = FirebaseFirestore.instance.collection('items');

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
                    });
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
                  onPressed: () {
                    final batch = FirebaseFirestore.instance.batch();
                    _confirmarComanda(batch, itemsComanda);
                  },
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Total: ${_comanda.map((i) => i.preu * i.quantitat).reduce((a, b) => a + b).toString()}€",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
