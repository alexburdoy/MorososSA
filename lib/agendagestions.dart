import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final iduser = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      
        body: StreamBuilder(
          
      stream: FirebaseFirestore.instance
                        .collection('agenda/${iduser}/idComanda')
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
              Text('Comandes realitzades'),
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
                child: Icon(Icons.keyboard_arrow_left),
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
