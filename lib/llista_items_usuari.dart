import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/templatepage.dart';

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
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final itemTriat = docs[index];
                        return ListTile(
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
                                "Preu: ${(itemTriat["preu"] * itemTriat["quantitat"])}",
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                          subtitle: Text(
                            "Personas: ${itemTriat["quantitat"]}",
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              color: Colors.grey[800],
                            ),
                          ),
                          onTap: (){
                            
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
                        return ListTile(
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
                                "Cantidad: ${itemTriat["quantitat"]}",
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              )
                              
                            ],
                            
                          ),
                          subtitle: Text(
                            "Precio: ${itemTriat["preu"]}",
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              color: Colors.grey[800],
                            ),
                          ),
                          onTap: (){
                              
                          },                         
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
      },
    ));
  }
}
