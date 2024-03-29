import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(SignUps());

String name = '';
String email = '';
String password = '';
bool loading = false;

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

  Future _signUp() async {
    if(name == '' || email == '' || password == '') {
      setState(() {
        loading = false;
      });
      return 'fail';
    } else {
      final res = await http.post(
        'https://test1-messenger-api.herokuapp.com/api/users',
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      return res;
    }
  }

  main() async {
    final sign = new SignUpBody();

      setState(() {
        loading = true;
      });
      try{
        final res = await sign._signUp();

        switch(res.statusCode){
          case 201: {
            setState(() {
              print(res.body);
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
            print(res.statusCode);
            print(res.body);
            setState(() {
              loading=false;
              email = '';
              password = '';
              name = '';
            });
            var response = json.decode(res.body);
            String message = response['message'];
            Toast.show(message, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          }
          break;
          default: {
            print(res.body);
            setState(() {
              loading=false;
              email = '';
              password = '';
              name = '';
            });
            Toast.show('Please recheck your datas!', context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            Navigator.pop(context, ':(');
          }
        }
      } catch (err) {
        setState(() {
          loading=false;
        });
        Toast.show('Please Fill All the Field!', context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        print('Catch Error : $err');
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
              main();
            },
            child: Text('Signup!'),
          ),
        ],
      ),
    );
  }
}