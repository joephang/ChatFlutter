import 'package:flutter/material.dart';

void main() => runApp(SignUps());

class SignUps extends StatelessWidget {
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
        title: Text('Sign Up'),
      ),
      body: SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  SignUpBody createState() => SignUpBody();
}

class SignUpBody extends State<SignUp> {
  @override

  String name = '';
  String username = '';
  String password = '';
  String phone = '';

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
                  username = text;
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number'
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fullname'
              ),
              onChanged: (text) {
                setState(() {
                  name = text;
                });
              },
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context, name);
            },
            child: Text('Signup!'),
          ),
        ],
      ),
    );
  }
}