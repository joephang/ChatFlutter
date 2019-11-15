import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

void main() => runApp(Profile());

class Response {
  String message;

  Response({
    this.message
  });

  factory Response.fromJson(Map<String, dynamic> parsedJson){
    return Response(
      message: parsedJson['message']
    );
  }
}

class Profile extends StatefulWidget {

  List profiled = List();

  Profile ({Key key, @required this.profiled});

  @override
  _Profile createState() => _Profile(profiles: profiled);
}

TextEditingController nameController = TextEditingController();
TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

var name = '';
var username = '';
var password = '';
String lol;

class _Profile extends State<Profile>{

  _update() async {
    print('Pressed');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.put(
        'https://test1-messenger-api.herokuapp.com/api/users/'+profiles[0]['_id'],
        body: {
          'name': name,
          'email': username,
        },
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token'
        });

    if(res.statusCode == 200){
      Toast.show('Update Success!', context);
      Navigator.pop(context);
    } else {
      print(res.body);

      var decodedd = json.decode(res.body);

      setState(() {
        lol = decodedd['message'];
      });

      print(lol == 'forbidden this is not your account');

//      Response wow = new Response.fromJson(json.decode(res.body));
//      print(wow.message);
    }
  }

  @override

  List profiles = List();

  _Profile ({Key key, @required this.profiles});

  initState() {
    super.initState();
    this.setState((){
      nameController = TextEditingController(text: profiles[0]['name']);
      usernameController = TextEditingController(text: profiles[0]['email']);
      passwordController = TextEditingController(text: profiles[0]['password']);
      name = profiles[0]['name'];
      username = profiles[0]['email'];
      password = profiles[0]['password'];
    });

    print(profiles[0]['email']);
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                _update();
              },
            ),
          )
        ],
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Leaving Profile Page'),
                  content: Text('You are leaving without saving'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text('No'),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
            }
          );
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.account_circle),
                title: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name'
                  ),
                  onChanged: (text) {
                    name= text;
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.verified_user),
                title: TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email'
                  ),
                  onChanged: (text) {
                    username=text;
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.vpn_key),
                title: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password'
                  ),
                  onChanged: (text) {
                    password=text;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }