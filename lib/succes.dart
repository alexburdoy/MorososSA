import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/templatepage.dart';
import 'main.dart';

class Success extends StatelessWidget {
  const Success({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal[200],
        child: Center(
          child: Text(
            '¡Completed!',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ), 
          ),
        ),
      ),
    );
  }
}


