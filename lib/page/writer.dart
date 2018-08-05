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

  String _background = '';

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
        debugPrint("($sx,$sy,$ex,$ey)");
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
        child: new Stack(
          alignment: Alignment.center,
          children: <Widget>[
            new Text(
              '$_background',
              style: TextStyle(fontSize: 150.0),
            ),
            // 田字格|三线格
            new Opacity(
                opacity: 0.5,
                child: new Container(
                  child: new Stack(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Expanded(
                              child: new Column(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Container(
                                      decoration: new BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(2.5),
                                          border: Border.all(
                                              color: Colors.amber, width: 2.5)),
                                    ),
                                    flex: 1,
                                  ),
                                  new Expanded(
                                    child: new Container(
                                      decoration: new BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2.5),
                                          border: Border.all(
                                              color: Colors.amber, width: 2.5)),
                                    ),
                                    flex: 1,
                                  )
                                ],
                              ),
                              flex: 1),
                          new Expanded(
                              child: new Column(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Container(
                                      decoration: new BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2.5),
                                          border: Border.all(
                                              color: Colors.amber, width: 2.5)),
                                    ),
                                    flex: 1,
                                  ),
                                  new Expanded(
                                    child: new Container(
                                      decoration: new BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2.5),
                                          border: Border.all(
                                              color: Colors.amber, width: 2.5)),
                                    ),
                                    flex: 1,
                                  )
                                ],
                              ),
                              flex: 1)
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new Expanded(
                              child: new Container(
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.5),
                                    border: Border.all(
                                        color: Colors.amber, width: 2.5)),
                              ),
                              flex: 1),
                          new Expanded(
                              child: new Container(
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.5),
                                    border: Border.all(
                                        color: Colors.amber, width: 2.5)),
                              ),
                              flex: 1),
                          new Expanded(
                              child: new Container(
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.5),
                                    border: Border.all(
                                        color: Colors.amber, width: 2.5)),
                              ),
                              flex: 1),


                        ],
                      )
                    ],
                  ),
                  color: Colors.amberAccent,
                  width: 200.0,
                  height: 200.0,
                )),
            new Container(
              child: new Signature(controller: _controller),
              width: 200.0,
              height: 200.0
            )
          ],
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
  void initState() {
    widget.socket.listen((event){
      setState(() {
        var b = widget.socket.read(2);
        _background = String.fromCharCode((((b[0] & 0xFF) << 8) | (b[1] & 0xFF)));
      });
    });
  }

  @override
  void dispose() {
    widget.socket.close();
    super.dispose();
  }
}
