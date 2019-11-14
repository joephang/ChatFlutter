import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

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
  String email = '';
  String password = '';

  bool loading = false;

  _SignUp() async {

    if(name != '' && email != '' && password != ''){
      final res = await http.post(
          'https://test1-messenger-api.herokuapp.com/api/users',
          body: {
            'name' : name,
            'email' : email,
            'password' : password,
          }
      );

      switch(res.statusCode){
        case 201: {
          setState(() {
            email = '';
            password = '';
            name = '';
            loading=false;
          });
          Toast.show('Register Succeed!', context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          Navigator.pop(context, ':(');
        }
        break;
        case 400 : {
          print(res.body);
          Toast.show('Error Unidentified', context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      }
    } else {
      Toast.show('Please Fill all the Form!', context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }

  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: loading ? CircularProgressIndicator() : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
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
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password'
              ),
              onChanged: (text) {
                setState(() {
                  password = text;
                });
              },
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
              setState(() {
                loading = true;
              });
              _SignUp();
            },
            child: Text('Signup!'),
          ),
        ],
      ),
    );
  }
}