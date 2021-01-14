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
        return Expanded(
            child:
                /*ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final itemTriat = docs[index];
              return ListTile(
                title: Row(
                  children: [
                    Text(
                      itemTriat.nom,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    /*Text(
                      "Preu: ${(itemTriat.preu * itemTriat.quantitat)}",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    )*/
                  ],
                ),
                /*subtitle: Text(
                  "Quantitat: ${itemTriat.quantitat}",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[800],
                  ),
                ),*/
              );
            },
          ),*/
                Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text('${docs['nom']}')],
        ));
      },
    ));
  }
}
