import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/templatepage.dart';
import 'paginaresum.dart';

class LlistaItemsUsuari extends StatefulWidget {
  final String barcode;
  final bool isAdmin;
  final String userID;
  final String comandaUserID;
  LlistaItemsUsuari({
    this.barcode,
    this.isAdmin = false,
    this.userID,
    this.comandaUserID,
  });
  @override
  _LlistaItemsUsuariState createState() => _LlistaItemsUsuariState();
}

class _LlistaItemsUsuariState extends State<LlistaItemsUsuari> {
  final List<String> names = <String>[];
  final List<int> nums = <int>[];
  final List<int> ind = <int>[];
  final List<double> preuItem = <double>[];
  double preuTotal=0;

  void addItemToList(String nom, int quant, int index, double preu) {
    setState(
      () {
        names.insert(0, nom);
        nums.insert(0, quant);
        ind.insert(0, index);
        preuItem.insert(0, preu);
      },
    );
  }

  void removeItemToList(int index) {
    setState(() {
      names.removeAt(index);
      nums.removeAt(index);
      ind.removeAt(index);
      preuItem.removeAt(index);
    });
  }

//MaterialColor _color = Colors.green;

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('comandes/${widget.barcode}/items')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error);
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final docs = snapshot.data.docs;
        if (!widget.isAdmin) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Seleccionats - Preu total: ${preuTotal}"),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.teal),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: names.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Row(
                              children: [
                                Text(
                                  names[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.delete),
                              ],
                            ),
                            onTap: () {
                              int value = docs[ind[index]]["quantitat"];
                              value++;
                              preuTotal -= preuItem[index];
                              FirebaseFirestore.instance
                                  .collection('comandes')
                                  .doc(widget.barcode)
                                  .collection("items")
                                  .doc(docs[ind[index]].documentID)
                                  .update({'quantitat': value});
                              removeItemToList(index);
                              if (value >= 0) {
                                setState(() {
                                  //_color = Colors.green;
                                });
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Text("Llista Items a triar"),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.teal),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final itemTriat = docs[index];

                          return Container(
                            //color: _color,
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    itemTriat["nom"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Quantitat: ${itemTriat["quantitat"]}",
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  )
                                ],
                              ),
                              subtitle: Text(
                                "Preu/U: ${itemTriat["preu"]}€",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey[800],
                                    fontSize: 12),
                              ),
                              onTap: () {
                                if (itemTriat["quantitat"] > 0) {
                                  int nouValor = itemTriat["quantitat"];
                                  preuTotal += itemTriat["preu"];
                                  nouValor--;
                                  if (nouValor <= 0) {
                                    setState(() {
                                      //  _color = Colors.red;
                                    });
                                  }
                                  addItemToList(itemTriat["nom"], nouValor,
                                      index, itemTriat['preu']);
                                  FirebaseFirestore.instance
                                      .collection('comandes')
                                      .doc(widget.barcode)
                                      .collection("items")
                                      .doc(docs[index].documentID)
                                      .update({'quantitat': nouValor});
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('comandes/${widget.barcode}/usuaris')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return ErrorWidget(snapshot.error);
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final docs = snapshot.data.docs;
                      if (!widget.isAdmin) {
                        return Container(
                          child: Row(
                            children: [
                              FloatingActionButton(
                                child: Icon(Icons.supervised_user_circle),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Usuaris Connectats'),
                                          content:
                                              setupAlertDialogContainer(docs),
                                        );
                                      });
                                },
                              ),
                              Spacer(),
                              RaisedButton(
                                onPressed: names.isEmpty
                                    ? null
                                    : () {
                                        final itemsUsuari = FirebaseFirestore
                                            .instance
                                            .collection(
                                                'comandes/${widget.barcode}/usuaris/${widget.comandaUserID}/itemsUser');

                                        final batch =
                                            FirebaseFirestore.instance.batch();
                                        for (var item in names) {
                                          batch.set(
                                              itemsUsuari.doc(), {'nom': item});
                                        }
                                        /*for (var item in preuItem) {
                                          batch.set(itemsUsuari.doc(),
                                              {'preu': item});
                                        }*/
                                        batch.commit();

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ResumSesio(
                                              isAdmin: false,
                                              idUsuariDoc: widget.comandaUserID,
                                              barcode: widget.barcode,
                                            ),
                                          ),
                                        );
                                      },
                                color: Colors.teal[400],
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.teal[400])),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          );
        }
        if (widget.isAdmin) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Seleccionats - Preu total: ${preuTotal}"),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.teal),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: names.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Row(
                              children: [
                                Text(
                                  names[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.delete),
                              ],
                            ),
                            onTap: () {
                              int value = docs[ind[index]]["quantitat"];
                              value++;
                              preuTotal -= preuItem[index];
                              FirebaseFirestore.instance
                                  .collection('comandes')
                                  .doc(widget.barcode)
                                  .collection("items")
                                  .doc(docs[ind[index]].documentID)
                                  .update({'quantitat': value});
                              removeItemToList(index);
                              if (value >= 0) {
                                setState(() {
                                  //_color = Colors.green;
                                });
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Text("Llista Items a triar"),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.teal),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final itemTriat = docs[index];

                          return Container(
                            //color: _color,
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    itemTriat["nom"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Quantitat: ${itemTriat["quantitat"]}",
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  )
                                ],
                              ),
                              subtitle: Text(
                                "Preu/U: ${itemTriat["preu"]}€",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey[800],
                                    fontSize: 12),
                              ),
                              onTap: () {
                                if (itemTriat["quantitat"] > 0) {
                                  int nouValor = itemTriat["quantitat"];
                                  preuTotal += itemTriat["preu"]; 
                                  nouValor--;
                                  if (nouValor <= 0) {
                                    setState(() {
                                      //  _color = Colors.red;
                                    });
                                  }
                                  addItemToList(itemTriat["nom"], nouValor,
                                      index, itemTriat['preu']);
                                  FirebaseFirestore.instance
                                      .collection('comandes')
                                      .doc(widget.barcode)
                                      .collection("items")
                                      .doc(docs[index].documentID)
                                      .update({'quantitat': nouValor});
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('comandes/${widget.barcode}/usuaris')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return ErrorWidget(snapshot.error);
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final docs = snapshot.data.docs;
                      if (widget.isAdmin) {
                        return Container(
                          child: Row(
                            children: [
                              FloatingActionButton(
                                child: Icon(Icons.supervised_user_circle),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Usuaris Connectats'),
                                          content:
                                              setupAlertDialogContainer(docs),
                                        );
                                      });
                                },
                              ),
                              Spacer(),
                              RaisedButton(
                                onPressed: names.isEmpty
                                    ? null
                                    : () {
                                        final itemsUsuari = FirebaseFirestore
                                            .instance
                                            .collection(
                                                'comandes/${widget.barcode}/usuaris/${widget.comandaUserID}/itemsUser');

                                        final batch =
                                            FirebaseFirestore.instance.batch();
                                        for (var item in names) {
                                          batch.set(
                                              itemsUsuari.doc(), {'nom': item});
                                        }

                                        batch.commit();

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ResumSesio(
                                              isAdmin: true,
                                              idUsuariDoc: widget.comandaUserID,
                                              barcode: widget.barcode,
                                            ),
                                          ),
                                        );
                                      },
                                color: Colors.teal[400],
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.teal[400])),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          );
        }
      },
    ));
  }

  Widget setupAlertDialogContainer(docs) {
    return Container(
        height: 300.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final user = docs[index];
            return ListTile(
              title: Text(user['nomUsuari']),
              /*subtitle: Text(
                user['email'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
              ), */
            );
          },
        ));
  }
}
