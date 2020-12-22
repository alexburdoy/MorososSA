import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _email, _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _showError(FirebaseAuthException error, BuildContext context) {
    String message;
    switch (error.code) {
      case "user-not-found":
      case "wrong-password":
        message = 'Wrong email password combination';
        break;
      case "weak-password":
        message = "The password is too weak (6 characters at least)";
        break;
      case "invalid-email":
        message = "The email is invalid";
        break;
      case "too-many-requests":
        message = "Too many login attempts. Try again later.";
        break;
      default:
        message = "AUTH ERROR: '${error.code}'";
    }
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _signInWithEmailAndPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
    } on FirebaseAuthException catch (e) {
      _showError(e, context);
    } catch (e) {
      print("OTHER ERROR: $e");
    }
  }

  void _createUserWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _showError(e, context);
    } catch (e) {
      print("OTHER ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 46, 69),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Builder(
              builder: (context) => Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset('assets/LogoApp.png'),
                        Spacer(),
                        Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 28,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'email',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'password',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        FlatButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () => _signInWithEmailAndPassword(context),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Need an account?'),
                            SizedBox(width: 10),
                            FlatButton(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (_) => RegisterScreen(),
                                  ),
                                )
                                    .then((result) {
                                  _createUserWithEmailAndPassword(
                                      result.email, result.password, context);
                                });
                              },
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}
