import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/templatepage.dart';
import 'main.dart';

class ResumSesio extends StatefulWidget {
  final String barcode;
  final bool isAdmin;
  ResumSesio({
    this.barcode,
    this.isAdmin = false,
  });
  @override
  _ResumSesioState createState() => _ResumSesioState();
}

class _ResumSesioState extends State<ResumSesio> {
  final List<String> names = <String>[];
  final List<int> nums = <int>[];
  final List<int> ind = <int>[];

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
                Text("Selected items"),
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
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                        color: Colors.teal[400],
                        child: Text(
                          "Finish",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.teal[400])),
                      ),
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
