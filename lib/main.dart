import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp/llista_items_usuari.dart';
//import 'package:flutterapp/screens/qr_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'sign_in_flow/auth_state_switch.dart';
import 'widgets/templatepage.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'introitem_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    AuthStateSwitch(
      app: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final db = FirebaseFirestore.instance;
    //final authUser = FirebaseAuth.instance.currentUser;

    return TemplatePage(
      body: Column(
        children: [
          Expanded(flex: 3, child: _BotoQR()),
          Expanded(flex: 2, child: _CrearSessio()),
          Expanded(flex: 1, child: _ObrirAgenda()),
        ],
      ),
      /*StreamBuilder(
        stream: db.collection('usuaris').doc(authUser.uid).snapshots(),
        builder: (context, snapshot) {
          var user;
          if (snapshot.hasData) {
            user = snapshot.data;
          }
          return StreamBuilder(
            stream: db
                .collection('comandes')
                .doc('2v9lPXfLHmnQxbpI83r0')
                .collection('items')
                .doc('bubFp45RVuInquT445yt')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final doc = snapshot.data;
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${user['nom']}'),
                    Text('${user['email']}'),
                    Text('${authUser.uid}'),
                    Text('${authUser.email}'),
                    Text(
                      'Nom: ${doc['nom']}\nPreu: ${doc['preu']}\nQuantitat: ${doc['quantitat']}',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),*/
    );
  }
}

class _BotoQR extends StatelessWidget {
  Future<String> _scan() async {
    await Permission.camera.request();
    String barcode = await scanner.scan();
    return barcode;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 250,
          width: 250,
          child: RaisedButton(
            onPressed: () async {
              final barcode = await _scan();
              final comandes =
                  FirebaseFirestore.instance.collection('comandes');
              final comandaref = comandes.doc();
              final users = comandaref.collection('usuaris').doc();
              final batch = FirebaseFirestore.instance.batch();
              batch.set(users, {
                "idusuari": FirebaseAuth.instance.currentUser.uid,
              });
              batch.commit();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LlistaItemsUsuari(barcode: barcode),
                ),
              );
            },
            color: Colors.teal[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 150,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Escanejar QR",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.teal[300])),
          ),
        ),
      ],
    );
  }
}

class _CrearSessio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: RaisedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => IntroItem(),
                ),
              );
            },
            color: Colors.teal[400],
            child: Text(
              "Crear sessió",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.teal[400])),
          ),
        ),
      ],
    );
  }
}

class _ObrirAgenda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          child: RaisedButton(
            onPressed: () {},
            color: Colors.teal[200],
            child: Text(
              "Agenda de deutes",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.teal[200])),
          ),
        ),
      ],
    );
  }
}

/*
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/
