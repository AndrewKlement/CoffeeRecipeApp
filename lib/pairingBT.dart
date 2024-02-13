import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';


class Pairpage extends StatefulWidget {
  final bool pairState;
  final Function bt_connect;
  Pairpage(this.pairState, this.bt_connect);

  @override
  State<Pairpage> createState() => _PairpageState();
}

class _PairpageState extends State<Pairpage> {
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>.empty(growable: true);
  List<String> connection_prog = [];

  @override
  void initState() {
    super.initState();
    request_permission();
  }

  void request_permission()async{
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetooth
    ].request();
    restartDiscovery();
    startDiscovery();
  }

  void restartDiscovery() {
    setState(() {
      results.clear();
    });
  }
  
  void startDiscovery() {
      _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
        setState(() {
          final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
          if (existingIndex >= 0)
            results[existingIndex] = r;
          else
            results.add(r);
        
          for(var i in results){
            connection_prog.add('');
            print('rssi ${i.rssi}');
            print(i.device.name);
          }
        });
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
            child: ListTile(
              title: Text('Scaned Device', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),),
              subtitle: Text('Pair your device to unlock the full capablities of the app',
              style: TextStyle( fontSize: 15))
            ),
          ),

          Card(
            margin:EdgeInsets.fromLTRB(0, 200, 0, 0), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0)
            ),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: results.length,
              itemBuilder: (context, index) => results[index].device.name != null ? 
                GestureDetector(
                  onTap: () async{
                    connection_prog[index] = 'connecting';
                    setState(() {});
                    await widget.bt_connect(results[index].device.address, index, context);
                    if(!widget.pairState){
                      connection_prog[index] = 'cannot connect';
                      setState(() {});
                    }
                  },
                  child: Container(
                  child: ListTile(
                    leading: Container(
                      height: 25,
                      child: VerticalDivider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(results[index].device.name != null ? results[index].device.name : '', 
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                    subtitle: Text(((){
                      if(connection_prog[index] == 'connecting'){
                        return 'Connecting...';
                      }
                      if(connection_prog[index] == 'cannot connect'){
                        return 'Cannot connect';
                      }
                      else{
                        return '';
                      }
                    }()), 
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),

                  ),
                ),
                ) : 
                Container(),
            )
          )
        ],
      ),
    );
  }
}