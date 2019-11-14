import 'package:flutter/material.dart';
import 'package:chats/pages/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:convert';

void main() => runApp(SignIn());

String email = null;
String Password = null;
bool loading = false;
List token = List();

final TextEditingController userController = TextEditingController();
final TextEditingController passController = TextEditingController();

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Signins(),
    );
  }
}

class Signins extends StatefulWidget {
  @override
  SignInn createState() => SignInn();
}

class SignInn extends State<Signins>{

  _setString() async {

    setState(() {
      loading=true;
    });

    if(email != null && Password != null){
      SharedPreferences prefs = await SharedPreferences.getInstance();

        final res = await http.post(
            'https://test1-messenger-api.herokuapp.com/api/login',
            body: {
              'email' : email,
              'password' : Password
            }
        );

        switch(res.statusCode){
          case 200: {
            setState(() {
              token = json.decode(res.body) as List;
            });
            prefs.setString('token', token[0]['token']);

            final tok = await prefs.getString('token');

            print(tok);

            Navigator.pushReplacementNamed(context, "/api");
            prefs.setString('email', email);

            setState((){
              userController.clear();
              passController.clear();
              email = null;
              Password = null;
              loading = false;
            });

            Toast.show("Signed In!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          }
          break;
          default:{
            this.setState((){
              userController.clear();
              passController.clear();
              email = null;
              Password = null;
              loading = false;
            });
            Toast.show("Please re-check your email and password!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          }
          break;
        }
    } else {
      Toast.show('Please Fill the Form', context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

 @override
 Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: loading ? CircularProgressIndicator() : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: userController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
              onChanged: (text) {
                setState(() {
                  email = text;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password'
              ),
              onChanged: (text) {
                setState(() {
                  Password = text;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () {
                    _setString();
                  },
                  child: Text('Sign In!'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text('Sign Up!'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}