import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

void main() => runApp(Profile());

TextEditingController nameController = TextEditingController();
TextEditingController usernameController = TextEditingController();

var name = '';
var username = '';
var defUser = '';
var defName = '';
String lol;

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

class _Profile extends State<Profile>{

  Future deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.delete('https://test1-messenger-api.herokuapp.com/api/users/',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      }
    );

    return res;
  }

  main() async {
    final prof = new _Profile(profiles: profiles);
    final res = await prof.deleteUser();

    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/signin');
    Toast.show('Should be deleted', context);
  }

  _update() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if(username == defUser){
      final res = await http.put(
          'https://test1-messenger-api.herokuapp.com/api/users',
          body: {
            'name': name,
          },
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token'
          });

      if(res.statusCode == 200){
        Toast.show('Update Success!', context);
        Navigator.pop(context);
      } else {

        var decodedd = json.decode(res.body);

        setState(() {
          lol = decodedd['message'];
        });

//      Response wow = new Response.fromJson(json.decode(res.body));
//      print(wow.message);
      }
    } else if (name == defName){
      final res = await http.put(
          'https://test1-messenger-api.herokuapp.com/api/users',
          body: {
            'email': username,
          },
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token'
          });

      if(res.statusCode == 200){
        Toast.show('Update Success!', context);
        Navigator.pop(context);
      } else {

        var decodedd = json.decode(res.body);

        setState(() {
          lol = decodedd['message'];
        });

//      Response wow = new Response.fromJson(json.decode(res.body));
//      print(wow.message);
      }
    }
  }

  List profiles = List();

  @override
  _Profile ({Key key, @required this.profiles});

  initState() {
    super.initState();
    this.setState((){
      nameController = TextEditingController(text: profiles[0]['name']);
      usernameController = TextEditingController(text: profiles[0]['email']);
      name = profiles[0]['name'];
      username = profiles[0]['email'];
      defName = profiles[0]['name'];
      defUser = profiles[0]['email'];
    });
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
              onPressed: username == defUser && name == defName ? null : () {
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
            mainAxisSize: MainAxisSize.max,
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
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                        color: Colors.red,
                        child: Text('Delete Accout'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Are you sure to Delete Account?'),

                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('No'),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Yes'),
                                      onPressed: (){
                                        main();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  }