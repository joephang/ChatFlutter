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
//      bottomNavigationBar:
      body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Flexible(
                      child: StreamBuilder(
                        stream: null,
                          builder: (context, snapshot){
                            return ListView.builder(
                                itemCount: 20,
                                itemBuilder: (BuildContext context, int index){
                                  return ListTile(
                                    contentPadding: EdgeInsets.all(8.0),
                                    leading: Text('Sender'),
                                    title: Text(list[num]['title'],overflow: TextOverflow.ellipsis,
                                      maxLines: 5,),
                                    subtitle: Text('Time Stamp?'),
                                  );
                                }
//                                Text(list[num]['title']),
//                                Image.network(
//                                  list[num]['url'],
//                                  fit: BoxFit.cover,
//                                  height: 40.0,
//                                  width: 40.0,
//                                ),
                            );
                          },
                      )
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        // Button send image
                        Material(
                          child: new Container(
                            margin: new EdgeInsets.symmetric(horizontal: 1.0),
                            child: new IconButton(
                              icon: new Icon(Icons.image),
                              onPressed: (){

                              },
                              color: Colors.grey,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        Material(
                          child: new Container(
                            margin: new EdgeInsets.symmetric(horizontal: 1.0),
                            child: new IconButton(
                              icon: new Icon(Icons.face),
                              onPressed: (){

                              },
                              color: Colors.grey,
                            ),
                          ),
                          color: Colors.white,
                        ),

                        // Edit text
                        Flexible(
                          child: Container(
                            child: TextField(
                              style: TextStyle(color: Colors.grey, fontSize: 15.0),
                              //                    controller: textEditingController,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              //                    focusNode: focusNode,
                            ),
                          ),
                        ),

                        // Button send message
                        Material(
                          child: new Container(
                            margin: new EdgeInsets.symmetric(horizontal: 8.0),
                            child: new IconButton(
                              icon: new Icon(Icons.send),
                              onPressed: (){

                              },
                              color: Colors.grey,
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        border: new Border(top: new BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
                  ),
                ],
              )
            ],
          ),
          onWillPop: null
      )
    );
  }
}