import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(Api());

class Api extends StatefulWidget {
  @override
  APIBody createState() => APIBody();
}

var loading = false;
List list = List();

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

  @override

  void initState() {
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
            onPressed: (){
              Navigator.pop(context, 'Hehe');
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
              print('Go To Details Page');
            },
          );
        },
      )
    );
  }
}