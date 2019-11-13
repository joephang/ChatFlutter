import 'package:flutter/material.dart';
import 'package:chats/pages/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(SignIn());

String Username = null;
String Password = null;

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
    if(Username != null && Password != null){
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final String local = prefs.getString('local');

      print(local);

        final res = await http.post(
            'http://$local:8081/api/user/login',
            body: {
              'username' : Username,
              'password' : Password
            }
        );

        switch(res.statusCode){
          case 200: {
            Navigator.pushReplacementNamed(context, "/api");
            prefs.setString('username', Username);
            print(Username);
            this.setState((){
              userController.clear();
              passController.clear();
              Username = null;
              Password = null;
            });
            Toast.show("Berhasil", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
            print('Berhasil!');
          }
          break;
          case 403: {
            this.setState((){
              passController.clear();
              Password = null;
            });
            Toast.show("Wrong Password!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          }
          break;
          case 404: {
            this.setState((){
              userController.clear();
              passController.clear();
              Username = null;
            });
            Toast.show("User Not Found!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          }
          break;
          default:{
            this.setState((){
              userController.clear();
              passController.clear();
              Username = null;
            });
            Toast.show("Cannot Login!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
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
      child: Column(
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
                  Username = text;
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