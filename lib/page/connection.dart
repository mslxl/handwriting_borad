import 'package:flutter/material.dart';
import 'package:handwriting_borad/page/writer.dart';
import 'package:handwriting_borad/util.dart';
import 'dart:io';

class ConnectionPage extends StatefulWidget {
  ConnectionPage({Key key}) : super(key: key);

  final String title = "Connect Server";

  @override
  _ConnectionPageState createState() => new _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Builder(builder: (BuildContext context) {
        return new Center(
            child: new Container(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(child: new TextField(
                controller:_textController,
                decoration: new InputDecoration.collapsed(hintText: 'Input Server IP'),
              )),
              new IconButton(
                  icon: new Icon(Icons.arrow_forward),
                  onPressed: () {
                    RawSocket
                        .connect(_textController.text, 8288, timeout: Duration(seconds: 5))
                        .catchError((e) {
                      Scaffold.of(context).showSnackBar(
                          new SnackBar(content: new Text(e.toString())));
                    }).then((socket) {
                      if (socket != null) {
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return new WriterPage(socket: socket);
                        }));
                      }
                    });
                  })
            ],
          ),
          padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.all(10.0),
        ));
      }),
    );
  }
}
