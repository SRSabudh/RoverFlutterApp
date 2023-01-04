import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

const String serviceUUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
const String RXUUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
const String TXUUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";

class Control extends StatefulWidget{

  final BluetoothDevice rover;
  const Control({Key? key, required this.rover}) : super(key: key);

  @override
  ControlState createState() => ControlState();

}

class ControlState extends State<Control>{

  late BluetoothCharacteristic rX;

  @override
  void initState(){
    widget.rover.connect().then((value) => discoverServices());
    super.initState();
  }

  @override
  void dispose(){
    widget.rover.disconnect();
    super.dispose();
  }

  void discoverServices() async{
    widget.rover.discoverServices()
        .then((value) => value.forEach((element) {
      if(element.uuid.toString().contains(serviceUUID.toLowerCase())){
        element.characteristics.forEach((characteristic) {
          if(characteristic.properties.write | characteristic.properties.writeWithoutResponse){
            rX = characteristic;
          }
        });
      }
    }));
  }


  bool _buttonPressed = false;
  bool _loopActive = false;

  void _increaseCounterWhilePressed(String msg) async {

    if (_loopActive) return;// check if loop is active

    _loopActive = true;

    while (_buttonPressed) {
      // do your thing
      sendToRover(msg);
      print(msg);
      // wait a second
      await Future.delayed(const Duration(milliseconds: 100));
    }
    _loopActive = false;
  }

  // send msg to rover
  Future sendToRover(String msg) async
  {
    //print(msg);
    await rX.write(utf8.encode(msg));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: const Text("Control")
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: Listener(
                onPointerDown: (details) {
                  _buttonPressed = true;
                  _increaseCounterWhilePressed("left");
                },
                onPointerUp: (details) {
                  _buttonPressed = false;
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.orange, border: Border.all()),
                  padding: const EdgeInsets.all(16.0),
                  child: const Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Listener(
                    onPointerDown: (details) {
                      _buttonPressed = true;
                      _increaseCounterWhilePressed("up");
                    },
                    onPointerUp: (details) {
                      _buttonPressed = false;
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.orange, border: Border.all()),
                      padding: const EdgeInsets.all(16.0),
                      child: const Icon(Icons.arrow_circle_up),
                    ),
                  ),
                ),
                SizedBox(
                  child: Listener(
                    onPointerDown: (details) {
                      _buttonPressed = true;
                      _increaseCounterWhilePressed("stop");
                    },
                    onPointerUp: (details) {
                      _buttonPressed = false;
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.orange, border: Border.all()),
                      padding: const EdgeInsets.all(16.0),
                      child: const Icon(Icons.stop_circle_outlined),
                    ),
                  ),
                ),
                SizedBox(
                  child: Listener(
                    onPointerDown: (details) {
                      _buttonPressed = true;
                      _increaseCounterWhilePressed("down");
                    },
                    onPointerUp: (details) {
                      _buttonPressed = false;
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.orange, border: Border.all()),
                      padding: const EdgeInsets.all(16.0),
                      child: const Icon(Icons.arrow_circle_down),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              child: Listener(
                onPointerDown: (details) {
                  _buttonPressed = true;
                  _increaseCounterWhilePressed("right");
                },
                onPointerUp: (details) {
                  _buttonPressed = false;
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.orange, border: Border.all()),
                  padding: const EdgeInsets.all(16.0),
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
