import 'package:auto_control/switch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'joystick_controler.dart';
import 'slider_vertical.dart';

class JoystickUI extends StatelessWidget{
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Joystick"),
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
      body:
        Center(
          child: new Joystick()
        )
    );
  }
}