import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';

class TemplatePage extends StatelessWidget {
  final Widget body;
  TemplatePage({this.body});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 17, 61),
        title: Image.asset(
          'assets/LogoApp.png',
          width: 150,
        ),
        actions: [],
      ),
      drawer: Container(
        width: 250,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: ,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {
                        HomePage();
                      },
                    ),
                    Text('Home'),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('LogOut'),
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            )
          ],
        ),
      ),
      body: this.body,
    );
  }
}
