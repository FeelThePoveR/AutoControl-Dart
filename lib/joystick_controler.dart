import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'dart:core';
import 'bluetooth.dart';
import 'switch.dart';

class Joystick extends StatefulWidget {

  final ValueChanged<Offset> onChanged;

  const Joystick({Key key, this.onChanged}) : super(key: key);

  @override
  JoystickState createState() => new JoystickState();
}

class JoystickState extends State<Joystick> {
  double xPos = 0.0;
  double yPos = 0.0;
  int il = 200, ir = 200;
  double scale = 100;
  
  Offset _value = Offset.zero;
  Offset get value => _value;
  

  void onChanged(Offset offset) {
    final RenderBox referenceBox = context.findRenderObject();
    Offset position = referenceBox.globalToLocal(offset);
    if (widget.onChanged != null)
      widget.onChanged(position);

    double width = referenceBox.size.width;
    double height = referenceBox.size.height;

    double x = position.dx;
    double y = position.dy;

    double dx, dy;

    double rad = sqrt(pow(x - (width / 2),2) + pow(y - (height / 2),2));
    rad = rad.ceilToDouble();

    if(rad>150){
      double tangens = (x - (width / 2))/(y - (height / 2));
      double sine = sqrt(pow(tangens,2)/(1+pow(tangens,2)));
      double cosine = sqrt(1/(1+pow(tangens,2)));

      dx = cosine*150;
      dy = sine*150;
    }

    setState(() {
      if(rad<=150){
        xPos = x - (width / 2);
        yPos = y - (height / 2);
      }
      else{
        if(x - (width / 2)>0 && y - (height / 2) > 0){
          yPos = dx.abs();
          xPos = dy.abs();
        }
        if(x - (width / 2) < 0 && y - (height / 2) < 0){
          yPos = -dx.abs();
          xPos = -dy.abs();
        }
        if(x - (width / 2) > 0 && y - (height / 2) < 0){
          yPos = -dx.abs();
          xPos = dy.abs();
        }
        if(x - (width / 2) < 0 && y - (height / 2) > 0){
          yPos = dx.abs();
          xPos = -dy.abs();
        }
      }
      updateOffset(xPos, -yPos);
    });
  }
  void onChangedEND(){
    setState(() {
      xPos = 0.0;
      yPos = 0.0;

      updateOffset(xPos, yPos);
    });
  }

  void updateOffset(double x, double y){
    _value = new Offset((x*scale)/150, (y*scale)/150);
    sendData();
    print(_value);
  }

  void sendData() async{
    double dx = _value.dx;
    double dy = _value.dy;

    double dl = dy+dx;
    double dr = dy-dx;

    il = dl.floor().clamp(-100, 100);
    ir = dr.floor().clamp(-100, 100);

    if(!inverted){
      int temp = il;
      il = -ir;
      ir = -temp;
    }

    il = il+200;
    ir = ir+200;

    print(il.toString()+"/"+ir.toString());

    String x = il.toString();
    String y = ir.toString();

    print("l = "+x+", r = "+y);

    bluetoothInstance.getstatus().send(x+"/"+y);
  }

  void _handlePanStart(DragStartDetails details) {
    onChanged(details.globalPosition);
  }

  void _handlePanEnd(DragEndDetails details) {
    onChangedEND();
    print('end');
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    onChanged(details.globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints.expand(),
      child: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart:_handlePanStart,
        onPanEnd: _handlePanEnd,
        onPanUpdate: _handlePanUpdate,
        child: new Stack(
          children: <Widget>[
            new CustomPaint(
              painter: new JoystickGridPainter(),
              child: new Center(
                child:new CustomPaint(
                  painter: new JoystickPainter(xPos, yPos),
                ),
              ),
            ),
            new Align(alignment: Alignment.bottomRight,
              child: new Text(_value.toString())
            ),
            new Align(alignment: Alignment.topLeft,
              child: new Text("Left: "+(il-200).toString()+" Right: "+(ir-200).toString())
            )
          ]
        )
      ),
    );
  }
}

class JoystickPainter extends CustomPainter {
  static const markerRadius = 10.0;

  Offset position;

  JoystickPainter(final double x, final double y) {
    this.position = new Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint()
      ..color = Colors.blue[400]
      ..style = PaintingStyle.fill;

    canvas.drawCircle(new Offset(position.dx, position.dy), markerRadius, paint);
  }

  @override
  bool shouldRepaint(JoystickPainter old) => position.dx != old.position.dx && position.dy !=old.position.dy;
}

class JoystickGridPainter extends CustomPainter {

  Offset position;

  JoystickGridPainter() {
    this.position = new Offset(0.0, 0.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint()
      ..color = Colors.blue[400]
      ..style = PaintingStyle.fill;

      Paint _paintControl = new Paint()
        ..color=new Color(0xffffffff)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

    Offset centreLeft = size.centerLeft(position);
    Offset centreRight = size.centerRight(position);

    canvas.drawLine(centreLeft, centreRight, paint);

    Offset topCentre = size.topCenter(position);
    Offset bottomCentre = size.bottomCenter(position);

    canvas.drawLine(topCentre, bottomCentre, paint);

    canvas.drawCircle(new Offset(size.width / 2.0, size.height / 2.0), 150.0, _paintControl);
  }


  @override
  bool shouldRepaint(JoystickGridPainter old) => position.dx != old.position.dx && position.dy !=old.position.dy;
}