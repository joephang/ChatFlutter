import 'dart:convert';
import 'package:chats/main.dart';
import 'package:chats/pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Api());

class Api extends StatefulWidget {
  @override
  APIBody createState() => APIBody();
}

var loading = false;
List list = List();
var username;

class APIBody extends State<Api> {

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
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('API GET'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              prefs.setString('username', null);
              Navigator.pop(context);
            }
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () {
            _apiGet();
            },
          child: Container(
            child: Text('API Get'),
          ),
        ),
      ),
      body: loading ? Center(
          child: CircularProgressIndicator(),
        ) : ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            contentPadding: EdgeInsets.all(8.0),
            trailing: Image.network(
              list[index]['thumbnailUrl'],
              fit: BoxFit.cover,
              height: 40.0,
              width: 40.0,
            ),
            title: Text(list[index]['title']),
            onTap: () {
              _getLocal();
            },
          );
        },
      )
    );
  }
}