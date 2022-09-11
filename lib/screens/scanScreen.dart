import 'dart:async';
import 'package:ble_project/genericWidgets/ScanResultTile.dart';
import 'package:ble_project/screens/DeviceScreen.dart';
import 'package:ble_project/screens/userDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import '../utils/AuthService.dart';
import 'BToffScreen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder<BluetoothState>(
              stream: FlutterBlue.instance.state,
              initialData: BluetoothState.unknown,
              builder: (c, snapshot) {
                final state = snapshot.data as BluetoothState;
                if (state == BluetoothState.on) {
                  return const FindDevicesScreen();
                }
                return BluetoothOffScreen(state: state);
              }),
        ));
  }
}

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 0.5,
        title: const Text('Scan for Devices'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.contacts_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserDetailScreen()));
            },
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.logout_sharp),
          onPressed: () async {
            await authService.signOut().then(((value) {
              print("Signing out");
            }));
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: const Duration(seconds: 5)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(const Duration(
                        seconds:
                            10)) //every 10 second will send info about connected devices
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                //async map: this stream waits for that future to complete before continuing with its result.
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return ElevatedButton(
                                    child: const Text('Open'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DeviceScreen(device: d))),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
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
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search),
                onPressed: () => FlutterBlue.instance.startScan(
                    timeout: const Duration(seconds: 5))); // 5 second to search
          }
        },
      ),
    );
  }
}
