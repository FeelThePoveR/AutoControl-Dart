import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'switch.dart';
import 'joystick.dart';
import 'bluetooth.dart';
import 'slider_vertical.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData.dark(),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("AutoControl"),
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
              },
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
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (BuildContext context) => 
                      new SliderVerUI()
                  )
                );
              },
            ),
            new Divider(),
            new MySwitchListTile(),
            new Divider(),
          ],
        )
      ),
      body: Center(
        child: bluetoothInstance
      )
    );
  }

}