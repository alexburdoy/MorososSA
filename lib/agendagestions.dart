import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/widgets/templatepage.dart';

class AgendaGestio extends StatefulWidget {
  final String idUsuariDoc;
  final String barcode;
  final bool isAdmin;

  AgendaGestio({
    this.idUsuariDoc,
    this.barcode,
    this.isAdmin = false,
  });
  @override
  _AgendaGestioState createState() => _AgendaGestioState();
}

class _AgendaGestioState extends State<AgendaGestio> {
  @override
  Widget build(BuildContext context) {
    return TemplatePage(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(
              'comandes/${widget.barcode}/usuaris/${widget.idUsuariDoc}/itemsUser')
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
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Llista Items Usuari'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.teal),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final userItem = docs[index];
                        return ListTile(
                          title: Text(
                            userItem['nom'],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                color: Colors.teal[400],
                child: Icon(Icons.arrow_forward),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.teal[400]),
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}
