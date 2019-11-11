import 'package:flutter/material.dart';
import 'package:chats/pages/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(SignIn());

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, ':(');
          },
        ),
        title: Text('Sign In'),
      ),
      body: Signins(),
    );
  }
}

class Signins extends StatefulWidget {
  @override
  SignInn createState() => SignInn();
}

class SignInn extends State<Signins>{

  String Username = '';
  String Password = '';

  _setString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', Username);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Api())
    );
  }
 @override
 Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
              onChanged: (text) {
                setState(() {
                  Username = text;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
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
          RaisedButton(
            onPressed: () {
              _setString();
            },
            child: Text('Sign In!'),
          ),
        ],
      ),
    );
  }
}