import 'package:flutter/material.dart';
import 'package:yconnect/googleSignInButton.dart';

class AuthPage extends StatefulWidget {

  final Function authenticate;

  AuthPage(this.authenticate);
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  final TextStyle brandNameStyle =
      TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 35.0);
  final TextStyle getStartedStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Roboto',
    fontSize: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 200.0,),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 4),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'YConnect',
                    style: brandNameStyle,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Watch your Favorite \n\nYouTube Videos \n\n Endlessly',
                        style: getStartedStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      GoogleSignInButton(
                        onPressed: (){
                          widget.authenticate(context);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );;
  }
}
