import 'dart:convert';
import 'dart:io';
import 'package:chats/pages/Details.dart';
import 'package:chats/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

void main() => runApp(Api());

var loading = false;
List list = List();
var email;
List profile = List();

class Api extends StatefulWidget {
  @override
  APIBody createState() => APIBody();
}

class APIBody extends State<Api> {

  userName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Emails = prefs.getString('email');
    this.setState((){
      email = Emails;
    });
  }

  _apiGet() async {
    setState(() {
      loading = true;
    });
    final res = await http.get('https://jsonplaceholder.typicode.com/photos');
    if(res.statusCode == 200){
      setState(() {
        list = json.decode(res.body) as List;
      });
      main();
    } else {
      setState(() {
        loading = false;
      });
      throw Exception('Failed Mas :(');
    }
  }

  Future profileGet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('token');
    final res = await http.get('https://test1-messenger-api.herokuapp.com/api/users/me', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    return res;
  }

  main() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final body = new APIBody();
    final res = await body.profileGet();

    setState(() {
      profile = json.decode(res.body) as List;
      loading = false;
    });
  }

  @override

  initState() {
    super.initState();
    _apiGet();
    userName();
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('API GET'),
      ),
      drawer: profile.length == 0 ?
      Icon(Icons.list) :
      Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60.0),
                      child: Image.network(
                          'https://scontent-sin6-1.cdninstagram.com/vp/5b0e2e1bc48ff972eba078bb63151a4a/5E8A2771/t51.2885-19/s150x150/75366265_426971247982562_503909228436520960_n.jpg?_nc_ht=scontent-sin6-1.cdninstagram.com&_nc_cat=102',
                          height: 60.0,
                          width: 60.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            profile.length == 0 ? Text('Hai!') :  Text(profile[0]['name']),
                            Text('This should be your status!')
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(profiled: profile,),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('Add Friend!'),
                  onTap: (){
                    Toast.show('Add Friend :3', context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: (){
                    Toast.show('Setting Page', context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sign Out'),
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('SignOut?'),
                            content: Text('Are you sure to Sign Out?'),
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
                                  prefs.setString('email', null);
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(context, "/signin");
                                },
                              ),
                            ],
                          );
                        }
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            _apiGet();
          },
        child: Icon(Icons.add),
      ),
      body: loading ? Center(
          child: CircularProgressIndicator(),
        ) : ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: Image.network(
              list[index]['thumbnailUrl'],
              fit: BoxFit.cover,
              height: 40.0,
              width: 40.0,
            ),
            title: Text(list[index]['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Details(list: list, num: index,),
                ),
              );
            },
          );
        },
      )
    );
  }
}