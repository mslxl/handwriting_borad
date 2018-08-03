import 'package:flutter/material.dart';

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}

class Signature extends StatefulWidget {

  Signature({Key key,this.controller});

  final SignatureController controller;

  SignatureState createState() => new SignatureState();
}

class SignatureController{
  List<Offset> points = <Offset>[];
  SignatureState _state;
  void clear(){
    points.clear();
  }

  void _setState(SignatureState state){
    this._state = state;
  }
}

class SignatureState extends State<Signature> {


  Widget build(BuildContext context) {
    return new Stack(
      children: [
        GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            RenderBox referenceBox = context.findRenderObject();
            Offset localPosition =
            referenceBox.globalToLocal(details.globalPosition);
            setState(() {
              widget.controller.points = new List.from(widget.controller.points)..add(localPosition);
            });
          },
          onPanEnd: (DragEndDetails details) => widget.controller.points.add(null),
        ),
        CustomPaint(painter: new SignaturePainter(widget.controller.points))
      ],
    );
  }
}
