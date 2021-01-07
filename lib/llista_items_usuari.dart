import 'package:flutter/material.dart';

class LlistaItemsUsuari extends StatefulWidget {
  @override
  _LlistaItemsUsuariState createState() => _LlistaItemsUsuariState();
}

class _LlistaItemsUsuariState extends State<LlistaItemsUsuari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Llista items'),
      ),
    );
  }
}