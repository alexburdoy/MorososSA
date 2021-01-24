import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/templatepage.dart';
import 'paginaresum.dart';

class LlistaItemsUsuari extends StatefulWidget {
  final String barcode;
  final bool isAdmin;
  LlistaItemsUsuari({
    this.barcode,
    this.isAdmin = false,
  });
  @override
  _LlistaItemsUsuariState createState() => _LlistaItemsUsuariState();
}

class _LlistaItemsUsuariState extends State<LlistaItemsUsuari> {
  final List<String> names = <String>[];
  final List<int> nums = <int>[];
  final List<int> ind = <int>[];

  void addItemToList(String nom, int quant, int index) {
    setState(
      () {
        names.insert(0, nom);
        nums.insert(0, quant);
        ind.insert(0, index);
      },
    );
  }

  void removeItemToList(int index) {
    setState(() {
      names.removeAt(index);
      nums.removeAt(index);
      ind.removeAt(index);
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
                Text("Seleccionats"),
                Expanded(
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
                            leading: Icon(Icons.delete),
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
                              ],
                            ),
                            onTap: () {
                              int value = docs[ind[index]]["quantitat"];
                              value++;
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
                  flex: 2,
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
                                "Preu: ${itemTriat["preu"]}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    color: Colors.grey[800],
                                    fontSize: 12),
                              ),
                              onTap: () {
                                if (itemTriat["quantitat"] > 0) {
                                  int nouValor = itemTriat["quantitat"];
                                  nouValor--;
                                  if (nouValor <= 0) {
                                    setState(() {
                                      //  _color = Colors.red;
                                    });
                                  }
                                  addItemToList(
                                      itemTriat["nom"], nouValor, index);
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
                Row(
                  children: [
                    Icon(Icons.supervised_user_circle),
                    Spacer(),
                    Icon(Icons.arrow_forward)
                  ],
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
                Text("Seleccionats"),
                Expanded(
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
                            leading: Icon(Icons.delete),
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
                              ],
                            ),
                            onTap: () {
                              int value = docs[ind[index]]["quantitat"];
                              value++;
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
                  flex: 2,
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
                                "Preu: ${itemTriat["preu"]}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    color: Colors.grey[800],
                                    fontSize: 12),
                              ),
                              onTap: () {
                                if (itemTriat["quantitat"] > 0) {
                                  int nouValor = itemTriat["quantitat"];
                                  nouValor--;
                                  if (nouValor <= 0) {
                                    setState(() {
                                      //  _color = Colors.red;
                                    });
                                  }
                                  addItemToList(
                                      itemTriat["nom"], nouValor, index);
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
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.supervised_user_circle),
                      onPressed: () {
                        // set up the button
                        Widget okButton = FlatButton(
                          child: Text("OK"),
                          onPressed: () {},
                        );

                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text("Usuaris Connectats"),
                          content: Container(
                            child: Text("This is my message."),
                          ),
                          actions: [
                            okButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      },
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.arrow_right_alt),
                      onPressed: () async {
                        Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ResumSesio(
                       
                      ),
                    ),
                  );
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        }
      },
    ));
  }
}
