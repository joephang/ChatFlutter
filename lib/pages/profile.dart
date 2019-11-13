import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

void main() => runApp(Profile());

class Profile extends StatefulWidget {

  List profiled = List();

  Profile ({Key key, @required this.profiled});

  @override
  _Profile createState() => _Profile(profiles: profiled);
}

TextEditingController nameController = TextEditingController();
TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController phoneController = TextEditingController();

var name = '';
var username = '';
var password = '';
var phone = '';

class _Profile extends State<Profile>{

  _update() async {
    print('Pressed');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String local = prefs.getString('local');

    final res = await http.put(
        'http://$local:8081/api/user/update/$username',
        body: {
          'name': name,
          'password': password,
          'phone': phone
        });

    if(res.statusCode == 200){
      Toast.show('Update Success!', context);
      Navigator.pop(context);
    } else {
      print(res.body);
    }
  }

  @override

  List profiles = List();

  _Profile ({Key key, @required this.profiles});

  initState() {
    super.initState();
    this.setState((){
      nameController = TextEditingController(text: profiles[0]['name']);
      usernameController = TextEditingController(text: profiles[0]['username']);
      passwordController = TextEditingController(text: profiles[0]['password']);
      phoneController = TextEditingController(text: profiles[0]['phone']);
      name = profiles[0]['name'];
      username = profiles[0]['username'];
      password = profiles[0]['password'];
      phone = profiles[0]['phone'];
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
                      labelText: 'Username'
                  ),
                  onChanged: (text) {
                    username=text;
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.vpn_key),
                title: TextField(
                  controller: passwordController,
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
              ListTile(
                leading: Icon(Icons.phone),
                title: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone'
                  ),
                  onChanged: (text) {
                    phone=text;
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