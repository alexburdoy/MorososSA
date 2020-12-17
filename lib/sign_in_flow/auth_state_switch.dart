import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/sign_in_screen.dart';

class AuthStateSwitch extends StatelessWidget {
  final Widget app;
  AuthStateSwitch({@required this.app});

  Widget _buildSplash({String message}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text(message)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasError) {
          return _buildSplash(message: snapshot.error.toString());
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildSplash(message: "Loading...");
          case ConnectionState.active:
            // Show different app depending on the user
            final user = snapshot.data;
            if (user == null) {
              return MaterialApp(home: SignInScreen());
            }
            return this.app;
          default:
            return _buildSplash(message: "unreachable");
        }
      },
    );
  }
}
