import 'dart:async';

import 'package:chats/pages/Details.dart';
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

  userName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    return username;
  }

  @override

  initState() {
    super.initState();
//    loops = Timer.periodic(Duration(seconds: 1), (timer){
//
//    });

    userName().then((result) => {
      if(result == null){
        this.setState(
            (){
              loading = false;
              logged = false;
            }
        )
      } else {
        this.setState((){
          logged = true;
          loading = false;
        })
      }
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build

    return(MaterialApp(
      title: 'Chats App',
      theme: ThemeData.dark(),
      home: loading ? Center(
        child: CircularProgressIndicator(),
      ) : logged ? Api() : SignIn(),
      routes: {
        '/home' : (_) => HomeBody(),
        '/signin' : (_) => SignIn(),
        '/signup' : (_) => SignUps(),
        '/api' : (_) => Api(),
        '/details' : (_) => Details()
      },
    ));
  }
}