import 'package:flutter/material.dart';

bool inverted=false;

class MySwitchListTile extends StatefulWidget {
  @override
  _MySwitchListTileState createState() => new _MySwitchListTileState();
}

class _MySwitchListTileState extends State<MySwitchListTile> {
  bool _value = inverted;
  @override
  Widget build(BuildContext context) {
    return  SwitchListTile(
      value:_value,
      onChanged: (value)=>setState((){
        _value=value;
        inverted = _value;
      }),
      title: new Text('Invert controls', style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
    );
  }
}