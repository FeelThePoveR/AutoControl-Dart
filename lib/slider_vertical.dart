import 'package:auto_control/switch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'joystick.dart';
import 'bluetooth.dart';

Slider slide = new Slider(title: 'Slider');

class SliderVerUI extends StatelessWidget{
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Slider'),
        elevation: defaultTargetPlatform == TargetPlatform.android?9.0:0.0,
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Autor: Tomasz Nowopolski"),
              accountEmail: new Text("Email:  nowopolski97@gmail.com"),
              decoration: new BoxDecoration(
                color: Colors.red,
              )
            ),
            new ListTile(
              title: new Text("Main"),
              trailing: new Icon(Icons.home),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.pop(context);
              }
            ),
            new Divider(),
            new ListTile(
              title: new Text("Joystick"),
              trailing: new Icon(Icons.album),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (BuildContext context) => 
                      new JoystickUI()
                  )
                );
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text("Slider"),
              trailing: new Icon(Icons.settings),
              onTap: (){
                Navigator.of(context).pop();
              },
            ),
            new Divider(),
            new MySwitchListTile(),
            new Divider(),
          ],
        )
      ),
      body:
        Center(
          child: slide
        )
    );
  }
}

class Slider extends StatefulWidget {
  Slider({Key key, this.title}) : super(key: key);

  final String title;

  @override

  _SliderState createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  double _leftValue = 0;
  double _rightValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30, left: 10, right: 200),
                  alignment: Alignment.centerLeft,
                  height: 500,
                  width: 80,
                  child: FlutterSlider(
                    values: [0],
                    max: 100,
                    min: -100,
                    axis: Axis.vertical,
                    rtl: true,
                    onDragCompleted: (handlerIndex, lowerValue, upperValue){
                      setState(() {
                        _leftValue = 0;
                        print(_leftValue);
                        sendData();
                      });
                    },
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      setState(() {
                        _leftValue = lowerValue;
                        print(_leftValue);
                        sendData();
                      });
                    },
                    handler: FlutterSliderHandler(
                      child: Icon(Icons.dehaze, color: Colors.grey, size: 24,)
                    ),
                    trackBar: FlutterSliderTrackBar(
                      activeTrackBarColor: Colors.redAccent,
                      activeTrackBarHeight: 5,
                      inactiveTrackBarColor: Colors.greenAccent.withOpacity(0.5),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, left: 0, right: 10),
                  alignment: Alignment.centerRight,
                  height: 500,
                  width: 80,
                  child: FlutterSlider(
                    values: [0],
                    max: 100,
                    min: -100,
                    axis: Axis.vertical,
                    rtl: true,
                    onDragCompleted: (handlerIndex, lowerValue, upperValue){
                      setState(() {
                        _rightValue = 0;
                        print(_rightValue);
                        sendData();
                      });
                    },
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      setState(() {
                        _rightValue = lowerValue;
                        print(_rightValue);
                        sendData();
                      });
                    },
                    handler: FlutterSliderHandler(
                      child: Icon(Icons.dehaze, color: Colors.grey, size: 24,)
                    ),
                    trackBar: FlutterSliderTrackBar(
                      activeTrackBarColor: Colors.redAccent,
                      activeTrackBarHeight: 5,
                      inactiveTrackBarColor: Colors.greenAccent.withOpacity(0.5),
                    ),
                  ),
                ),
              ]
            ),
            new Align(alignment: Alignment.topLeft,
              child: new Text("Left: "+(_leftValue).toString()+" Right: "+(_rightValue).toString())
            )
          ]
      )
    );
  }

  void sendData(){
    int il = _leftValue.toInt();
    int ir = _rightValue.toInt();

    if(!inverted){
      int temp = il;
      il = -ir;
      ir = -temp;
    }

    il = il+200;
    ir = ir+200;

    String l = il.toString();
    String r = ir.toString();

    print("l = "+l+", r = "+r);

    bluetoothInstance.getstatus().send(l+"/"+r);
  }
}

