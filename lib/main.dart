import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chats/pages/signup.dart';
import 'package:chats/pages/signin.dart';
import 'package:chats/pages/Home.dart';
import 'package:chats/pages/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyApp>{

  var logged = false;
  var loading = true;
  var loops;

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
        logged = false,
        loading = false
      } else {
        logged = true,
        loading = false
      }
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    if(loading == true){
      print('Ini Loading di true $loading');
      return MaterialApp(
        title: 'Chats App',
        theme: ThemeData.dark(),
        home: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      print('Ini Loading di else $loading');
      if(logged == true){
        print(logged);
        return MaterialApp(
          title: 'Chats App',
          theme: ThemeData.dark(),
          home: Api()
        );
      } else {
        print(logged);
        return MaterialApp(
            title: 'Chats App',
            theme: ThemeData.dark(),
            home: HomeBody()
        );
      }
    }
  }
}