import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserHomepage extends StatefulWidget {
  final FirebaseUser user;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  UserHomepage(this.user, this.auth, this.googleSignIn);

  @override
  _UserHomepageState createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  List _results = [];
  var youtube = new FlutterYoutube();
  String apiKey = "AIzaSyBMP1bc5m6XItvEIhLkyOh4sbGuX0nUy-I";

  Future _getVideos(String term) async {
    http.Response response = await http.get(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=25&q=${term}&type=video&regionCode=IN&key=${apiKey}');
    List results = json.decode(response.body)['items'];
    setState(() {
      _results = results;
    });
    print(_results);
  }

  Widget _buildPageContent() {
    return _results.length > 1
        ? Column(
            children: _results.map((video) {
            print(video['snippet']['thumbnails']);
            return Card(
              elevation: 8.0,
              margin: EdgeInsets.all(15.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.network(
                        video['snippet']['thumbnails']['high']['url']),
                    ListTile(
                      title: Text(video['snippet']['title']),
                      leading: Icon(Icons.play_arrow),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      child: Text(
                        'Play Now',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        FlutterYoutube.playYoutubeVideoByUrl(
                            apiKey: apiKey,
                            videoUrl:
                                "https://www.youtube.com/watch?v=${video['id']['videoId']}",
                            autoPlay: true, //default falase
                            fullScreen: true //default false
                            );
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList())
        : Text('Please select a Category to Fetch');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hello, ${widget.user.displayName}'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.all(60.0),
                child: Text(
                  'YConnect',
                  style: TextStyle(color: Colors.white, fontSize: 40.0),
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                          child: Image.network(
                        widget.user.photoUrl,
                        fit: BoxFit.cover,
                        width: 90.0,
                        height: 90.0,
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    widget.user.displayName,
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16.0),
                ),
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  widget.auth.signOut().whenComplete((){
                    widget.googleSignIn.signOut().whenComplete((){
                      Navigator.pushReplacementNamed(context, '/auth');
                    });
                  });
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.purple,
                          onPressed: () {
                            _getVideos("Music");
                          },
                          child: Text(
                            'Music',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        RaisedButton(
                          color: Colors.purple,
                          onPressed: () {
                            _getVideos("Movies");
                          },
                          child: Text(
                            'Movies',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.purple,
                          onPressed: () {
                            _getVideos("Technology");
                          },
                          child: Text(
                            'Technology',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        RaisedButton(
                          color: Colors.purple,
                          onPressed: () {
                            _getVideos("Fashion");
                          },
                          child: Text(
                            'Fashion',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              _buildPageContent(),
            ],
          ),
        ));
  }
}
