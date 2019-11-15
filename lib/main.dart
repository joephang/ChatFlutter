import 'dart:async';

import 'package:chats/pages/Details.dart';
import 'package:chats/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:chats/pages/signup.dart';
import 'package:chats/pages/signin.dart';
import 'package:chats/pages/Home.dart';
import 'package:chats/pages/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

var logged = false;
var loading = true;

class MyApp extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyApp>{

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('email');
    return username;
  }

  main() async {
    final home = new _MyHomePage();
    try{
      final result = await home.getUserName();
      print(result);
      if(result == null){
        this.setState(
                (){
              loading = false;
              logged = false;
            }
        );
      } else {
        this.setState((){
          logged = true;
          loading = false;
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override

  initState() {
    super.initState();
    main();
  }

  Widget build(BuildContext context) {
    // TODO: implement build

    return(
        MaterialApp(
          title: 'Chats App',
          routes: {
            '/home' : (_) => HomeBody(),
            '/signin' : (_) => SignIn(),
            '/signup' : (_) => SignUps(),
            '/api' : (_) => Api(),
          },
          theme: ThemeData.dark(),
          home: loading ? Center(
            child: CircularProgressIndicator(),
          ) : logged ? Api() : SignIn(),

        )
    );
  }
}