import 'package:flutter/material.dart';
import 'package:yconnect/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yconnect/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  FirebaseUser _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future _authenticate(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: gSA.idToken, accessToken: gSA.accessToken);
    if (user != null) {
      setState(() {
        _user = user;
      });
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YConnect',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      initialRoute: '/auth',
      routes: {
        '/': (BuildContext context) => UserHomepage(_user, _auth, googleSignIn) ,
        '/auth': (BuildContext context) => AuthPage(_authenticate) 
      }
    );
  }
}
