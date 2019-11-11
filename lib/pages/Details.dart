import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Details extends StatelessWidget {

  List list = List();
  var num = 0;

  Details({Key key, @required this.list, this.num});

  @override

  // TODO: implement widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(list[num]['title']),
            Image.network(
              list[num]['url'],
              fit: BoxFit.cover,
//              height: 40.0,
//              width: 40.0,
            ),
          ],
        ),
      ),
    );
  }
}