import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'package:flutter/services.dart';

BluetoothApp bluetoothInstance = new BluetoothApp();

class BluetoothApp extends StatefulWidget {
  _BluetoothAppState status = new _BluetoothAppState();
  @override
  _BluetoothAppState createState() => status;

  _BluetoothAppState getstatus(){
    return status;
  }
}

class _BluetoothAppState extends State<BluetoothApp> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    bluetoothConnectionState();
  }

  Future<void> bluetoothConnectionState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case FlutterBluetoothSerial.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
          });

          break;

        case FlutterBluetoothSerial.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;

        default:
          print(state);
          break;
      }
    });

    if (!mounted) {
      return;
    }

    setState(() {
      _devicesList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "PAIRED DEVICES",
              style: TextStyle(fontSize: 24, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Device:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton(
                  items: _getDeviceItems(),
                  onChanged: (value) => setState(() => _device = value),
                  value: _device,
                ),
                RaisedButton(
                  onPressed:
                    _pressed ? null : _connected ? _disconnect : _connect,
                  child: Text(_connected ? 'Disconnect' : 'Connect'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "NOTE: If you cannot find the device in the list, please turn on bluetooth and pair the device by going to the bluetooth settings",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      final snackBar = SnackBar(
        content: Text('No device selected'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth
              .connect(_device)
              .timeout(Duration(seconds: 10))
              .catchError((error) {
            setState(() => _pressed = false);
          });
          setState(() => _pressed = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _pressed = true);
  }

  void send(String x) {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.write(x);
        print(x);
      }
    });
  }

  Stream<String> read(){
    return bluetooth.onRead();
  }
}

class Streamhandler extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: bluetoothInstance.getstatus().read(),
      initialData: "0/0",
      builder: (BuildContext context, snapshot) {
        return new Container(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(snapshot.data),
            ),
          ],)
        );
      },
    );
  }
}