import 'package:flutter/material.dart';
import 'package:handwriting_borad/util.dart';
import 'dart:io';

import 'package:handwriting_borad/widget/signature.dart';

class WriterPage extends StatefulWidget {
  WriterPage({Key key, this.socket}) : super(key: key);

  final String title = "Handwriting";
  final RawSocket socket;

  @override
  _WriterPagePageState createState() => new _WriterPagePageState();
}

class _WriterPagePageState extends State<WriterPage> {
  SignatureController _controller = new SignatureController();

  List<Offset> get _points => _controller.points;

  void send(List<int> bytes) {
    widget.socket.write(bytes);
  }

  void sendInt(int num) {
    send(convertIntToByte(num));
  }

  void _sendPoints() {
    for (int i = 0; i < _points.length - 1; i++) {
      if (_points[i] != null && _points[i + 1] != null) {
        var sx = _points[i].dx.round();
        var sy = _points[i].dy.round();
        var ex = _points[i + 1].dx.round();
        var ey = _points[i + 1].dy.round();
        print("($sx,$sy,$ex,$ey)");
        sendInt(sx);
        sendInt(sy);
        sendInt(ex);
        sendInt(ey);
      }
    }
    for (int i = 0; i < 4; i++) {
      sendInt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Container(
          child: new Signature(controller: _controller),
          width: 250.0,
          height: 250.0,
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(2.5),
              border: Border.all(color: Colors.grey, width: 2.5)),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.send),
          onPressed: () {
            this._sendPoints();
            _controller.clear();
          }),
    );
  }

  @override
  void dispose() {
    widget.socket.close();
    super.dispose();
  }
}
