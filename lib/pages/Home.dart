import 'package:flutter/material.dart';
import 'package:chats/pages/signup.dart';
import 'package:chats/pages/signin.dart';

class HomeBody extends StatelessWidget {
  @override
  _navigateDisplaySignin(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUps())
    );
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Haii'),
          leading: null,
        ),
        body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  print('Pressed');
                  _navigateDisplaySignin(context);
                },
                textColor: Colors.white,
                padding: EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ])
                  ),
                  padding: EdgeInsets.all(12.5),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 8.0,),
              RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn())
                    );
                  },
                  textColor: Colors.white,
                  padding: EdgeInsets.all(0.0),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ])
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
              ),
            ],
          ),
        )
    );
  }
}