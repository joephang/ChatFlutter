import 'dart:convert';
import 'package:chats/main.dart';
import 'package:chats/pages/Details.dart';
import 'package:chats/pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

void main() => runApp(Api());

class Api extends StatefulWidget {
  @override
  APIBody createState() => APIBody();
}

var loading = false;
List list = List();
var username;

class APIBody extends State<Api> {

  userName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    print(username);
    return username;
  }

  _apiGet() async {
    setState(() {
      loading = true;
    });

    final res = await http.get('https://jsonplaceholder.typicode.com/photos');
    if(res.statusCode == 200){
      setState(() {
        list = json.decode(res.body) as List;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      throw Exception('Failed Mas :(');
    }
  }

  _getLocal() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String local = prefs.getString('username');
    print(local);
  }

  @override

  initState() {
    super.initState();
    _apiGet();
    userName().then((res) => {
      this.setState((){
        username = res;
      })
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('API GET'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.setString('username', null);
                Navigator.pushReplacementNamed(context, "/signin");
              },
              child: Center(
                child: Text('Log Out'),
              ),
              onLongPress: () async {

              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(120.0),
                      child: Image.network(
                          'https://scontent-sin6-1.cdninstagram.com/vp/5b0e2e1bc48ff972eba078bb63151a4a/5E8A2771/t51.2885-19/s150x150/75366265_426971247982562_503909228436520960_n.jpg?_nc_ht=scontent-sin6-1.cdninstagram.com&_nc_cat=102',
                          height: 120.0,
                          width: 120.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('$username'),
                    ),

                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Toast.show('Directing to Profile!', context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Add Friend!'),
              onTap: (){
                Toast.show('Add Friend :3', context);
              },
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