import 'package:flutter/material.dart';
import 'package:handwriting_borad/util.dart';
import 'dart:io';

import 'package:handwriting_borad/widget/signature.dart';

class WriterPage extends StatefulWidget {
  WriterPage({Key key, this.ip}) : super(key: key);

  final String title = "Handwriting";
  final String ip;

  @override
  _WriterPagePageState createState() => new _WriterPagePageState();

}

class _WriterPagePageState extends State<WriterPage> {
  List<Offset> _points = <Offset>[];
  RawSocket socket;

  void send(List<int> bytes) {
    socket.write(bytes);
  }
  void sendInt(int num){
    send(convertIntToByte(num));
  }

  void _sendPoints() async{
    // ignore: close_sinks
    for (int i = 0; i < _points.length - 1; i++) {
      if (_points[i] != null && _points[i + 1] != null) {
        var sx = _points[i].dx.round();
        var sy = _points[i].dy.round();
        var ex = _points[i+1].dx.round();
        var ey = _points[i+1].dy.round();
        print("($sx,$sy,$ex,$ey)");
        sendInt(sx);
        sendInt(sy);
        sendInt(ex);
        sendInt(ey);
      }
    }
    for(int i = 0; i < 4;i++){
      sendInt(0);
    }
  }

  void _connect(BuildContext context) async {
    if(socket == null){
      try{
        print("Try to connect ${widget.ip}:8288");
        socket = await RawSocket.connect(widget.ip, 8288,timeout: Duration(seconds: 2));
        print("Connect success");
      }catch(e){
        Navigator.pop(context);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    _connect(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Container(
          child: new Signature(
            onChanged: (List<Offset> offsets) {
              _points = offsets;
            },
          ),
          width: 250.0,
          height: 250.0,
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(2.5),
              border: Border.all(color: Colors.grey, width: 2.5)),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.send), onPressed: _sendPoints),
    );
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

}
