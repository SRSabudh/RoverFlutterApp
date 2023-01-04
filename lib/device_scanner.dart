import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'control.dart';


// *** Off Screen ***
class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// *** Scanner Screen ***
class FindDevicesScreen extends StatelessWidget {

  FindDevicesScreen({Key? key}) : super(key: key);

  final FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("Scan Rovers"),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            flutterBlue.startScan(allowDuplicates: false, scanMode: ScanMode.balanced, timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                  stream: flutterBlue.scanResults,
                  initialData: [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!.map((r) => Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: ListTile(
                        tileColor: Colors.black26,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        isThreeLine: true,
                        title: Text(r.device.name.toString()),
                        subtitle: Text("Type -> ${r.device.type.name.toString()} \n Device id -> ${r.device.id.id.toString()}"),
                        trailing: const Icon(Icons.bluetooth_sharp),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Control(rover: r.device)));
                        },
                      ),
                    )).toList(),
                  )
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
              child: const Icon(Icons.search),
              onPressed: () => FlutterBlue.instance
                  .startScan(timeout: const Duration(seconds: 4)),
              backgroundColor: Colors.lightGreen,);
          }
        },
      ),
    );
  }
}