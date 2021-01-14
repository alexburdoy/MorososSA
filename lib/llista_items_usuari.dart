import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/templatepage.dart';

class LlistaItemsUsuari extends StatefulWidget {
  final String barcode;
  LlistaItemsUsuari(this.barcode);
  @override
  _LlistaItemsUsuariState createState() => _LlistaItemsUsuariState();
}

class _LlistaItemsUsuariState extends State<LlistaItemsUsuari> {
  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      body: Container(
        child: Text("${widget.barcode}"),
      ),
    );
  }
}
