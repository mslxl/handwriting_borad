import 'package:flutter/material.dart';
import 'package:handwriting_borad/page/writer.dart';
import 'package:handwriting_borad/util.dart';


class ConnectionPage extends StatefulWidget {
  ConnectionPage({Key key}) : super(key: key);


  final String title = "Connect Server";

  @override
  _ConnectionPageState createState() => new _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  String _ip;
  void _connect(){
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
      return new WriterPage(ip:_ip);
    }));

  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
          child: new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text("Server IP:"),
                new Expanded(
                    child: new TextField(
                      onChanged: (t){
                        _ip = t;
                      },
                    )
                ),
                new IconButton(
                    icon: new Icon(Icons.arrow_forward),
                    onPressed: _connect)
              ],
            ),
            padding: EdgeInsets.all(5.0),
          )
      ),
    );
  }
}


