import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:recipe/pairingBT.dart';
import 'inventory.dart';
import 'addItem.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:core';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'start.dart';
import 'package:flutter/services.dart';
import 'journallist.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'pairingBT.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
  [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'recipe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor:Colors.grey.shade200
      ),
    
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {   
  List<Recipe> recipe=[];
  String category;
  final children = <Widget>[];
  List recipePath = [];
  List <GlobalKey> globalKey = [];
  bool pairState = false;
  BluetoothConnection connection;
  StreamSubscription bt_stream;
  bool listening = false;
  Timer bt_timer;
  String live_value;
  bool tare_Inprogress = false;

  void initState(){
    syncList();
    bt_timer = new Timer.periodic(new Duration(milliseconds: 400), (timer) {
      setState(() {
        if(connection != null && !connection.isConnected){
          pairState = false;
        }
      });
    });
    super.initState();
  }

  void bt_receive(){
    bt_stream = connection.input.listen((Uint8List data) {
    print('Data incoming: ${data}');
    live_value = utf8.decode(data); 
    if(live_value == '0.0'){
      tare_Inprogress = false;  
    }
    print('Data incoming: ${live_value}'); 
    setState(() {});
    }, onDone: () { 
        print('Disconnected by remote request');
        bt_stream.cancel();
      }
    );
  }

  void bt_send(data){
    connection.output.add(utf8.encode(data));
  }

  void bt_cancel(){
    bt_stream.cancel();
  }

  get_value(){
    return live_value;
  }

  void tare(){
    if(!tare_Inprogress){
      tare_Inprogress = true;
      bt_send('tare');
    }
  }

  void start(post) async {
    String file = await File(post.path).readAsString();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Prep(file, pairState, connection, bt_stream, bt_send, bt_cancel, get_value, tare)));
    print(file);
  }

  void syncList() async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory dirfol = Directory('${directory.path}/recipe');
    if(await dirfol.exists() == false){
      await dirfol.create(recursive: true);
    }
    setState(() {
      recipePath = dirfol.listSync();
      for(var i in recipePath){
        globalKey.add(GlobalKey());
      }
      print(recipePath);
    });
  }

  void click(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewItem(syncList)));
  }

  void pairingPage() async {
    setState(() {
      if(connection != null && !connection.isConnected){
        pairState = false;
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => Pairpage(pairState, bt_connect)));
    });
  }

  void bt_connect(var address, index, bt_context) async{
    try {
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');
      pairState = true;
      Navigator.pop(bt_context);
      bt_receive();
      setState(() {});
    }
    catch (exception){
      setState(() {
        print('Cannot connect');
        pairState = false;
      });
    }
  }

  @override
  void dispose() {
    bt_stream.cancel();
    bt_stream = null;
    bt_timer.cancel();
    connection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: 
      Stack(
        children:<Widget>[

          Padding(
            padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
            child: 
              ListTile(
                title: Text('Recipe', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),),
                subtitle: Text('Save your item now',  style: TextStyle( fontSize: 15))
              ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(285, 90, 0, 0),
            child: IconButton(
              onPressed: (){
                pairingPage();
              },
              iconSize: 25,
              color: pairState ? Colors.blue : Colors.black,
              icon: Icon(Icons.bluetooth)
            )
          ),
   
(((){
  if(recipePath.isEmpty){
    return Container(
      height: 400,
      margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
      child:PageView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children:<Widget>[
          Card(
            margin:EdgeInsets.fromLTRB(50, 0, 50, 25), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
            ),
            elevation: 10,
            child: ListTile(
              title:Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Text(
                  'Dont Have a Item ? ', 
                  style: TextStyle(
                  fontSize: 28
                  ),
                ),
              ),
              subtitle:Text('Add one right now by pressing the plus button', style: TextStyle(fontSize: 15),),
            ),
          ),
          
          GestureDetector(
            onTap: () async{
              FilePickerResult result = await FilePicker.platform.pickFiles();
              if(result != null){
                final Directory directory = await getApplicationDocumentsDirectory();
                final Directory dirfol = Directory('${directory.path}/recipe');
                if(await dirfol.exists() == false){
                  await dirfol.create(recursive: true);
                }
                final File file = File(result.files.single.path);
                String content = await File(file.path).readAsString();
                final File filepath = File('${dirfol.path}/${result.files.single.path.split('/').last.toString().replaceAll('.json', '')}.json');
                await filepath.writeAsString(content.toString());
                syncList();
              }
            },
            child: Card(
              margin:EdgeInsets.fromLTRB(50, 0, 50, 25),  
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
              ),
              elevation: 10,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: ListTile(
                    title: Text('Storage', style: TextStyle( fontSize: 30)),
                    subtitle: Text('Add recipe from storage',  style: TextStyle( fontSize: 20))
                  ),
                )
              )
            ),
          ),

          GestureDetector(
            onTap: (){
            },
            child: Card(
              margin:EdgeInsets.fromLTRB(50, 0, 50, 25),  
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
              ),
              elevation: 10,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: ListTile(
                    title: Text('Photo', style: TextStyle( fontSize: 30)),
                    subtitle: Text('Add recipe by scanning',  style: TextStyle( fontSize: 20))
                  ),
                )
              )
            ),
          )
        ]
      )
    );
  }
  else{
    return Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: <Widget> [
            Container(
              height: 400,
              margin: EdgeInsets.fromLTRB(0, 190, 0, 0),
              child:
              PageView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children:[
                  for (var index = 0; index < recipePath.length; index++)
                    GestureDetector(
                      onTap: (){
                        start(recipePath[index]);
                      },
                      onLongPress: (){
                        File(recipePath[index].path).deleteSync();
                        syncList();
                        setState(() {});
                      },
                      child: Card(
                      margin:EdgeInsets.fromLTRB(50, 0, 50, 25),  
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                      ),
                      elevation: 10,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 25, 0, 0),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 180,
                                      margin: EdgeInsets.only(top: 10),
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          recipePath[index].path.split('/').last.toString().replaceAll('.json', ''), 
                                          style: TextStyle(
                                            fontSize: 25
                                          ),
                                        )
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(185, 0, 0, 0),
                                      child:IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: (){
                                        Share.shareFiles([recipePath[index].path.toString()]);
                                      }
                                      )
                                    )
                                  ],
                                )
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: RepaintBoundary(
                                  key: globalKey[index],
                                  child: QrImage(
                                    data: File(recipePath[index].path).readAsStringSync(),
                                    version: QrVersions.auto,
                                    size: 200.0,
                                  )
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                    ),
                  
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Journallist()));
                    },
                    child: Card(
                      margin:EdgeInsets.fromLTRB(50, 0, 50, 25),  
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                      ),
                      elevation: 10,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                          child: ListTile(
                            title: Text('Journal', style: TextStyle( fontSize: 30)),
                            subtitle: Text('Tap to see all your journal',  style: TextStyle( fontSize: 20))
                          ),
                        )
                      )
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      if(pairState == true){
                        connection.finish();
                      }
                    },
                    child: Card(
                      margin:EdgeInsets.fromLTRB(50, 0, 50, 25),  
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                      ),
                      elevation: 10,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                          child: ListTile(
                            title: Text('Disconnect', style: TextStyle( fontSize: 30, color: Colors.red.shade400)),
                            subtitle: Text('Tap to disconnect bluetooth scale',  style: TextStyle( fontSize: 20, color: Colors.red.shade400.withOpacity(0.8)))
                          ),
                        )
                      )
                    ),
                  ),

                  GestureDetector(
                    onTap: () async{
                      FilePickerResult result = await FilePicker.platform.pickFiles();
                      if(result != null){
                        final Directory directory = await getApplicationDocumentsDirectory();
                        final Directory dirfol = Directory('${directory.path}/recipe');
                        if(await dirfol.exists() == false){
                          await dirfol.create(recursive: true);
                        }
                        final File file = File(result.files.single.path);
                        String content = await File(file.path).readAsString();
                        final File filepath = File('${dirfol.path}/${result.files.single.path.split('/').last.toString().replaceAll('.json', '')}.json');
                        await filepath.writeAsString(content.toString());
                        syncList();
                      }
                    },
                    child: Card(
                      margin:EdgeInsets.fromLTRB(50, 0, 50, 25),  
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                      ),
                      elevation: 10,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                          child: ListTile(
                            title: Text('Storage', style: TextStyle( fontSize: 30)),
                            subtitle: Text('Add recipe from storage',  style: TextStyle( fontSize: 20))
                          ),
                        )
                      )
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: (){
                    },
                    child: Card(
                      margin:EdgeInsets.fromLTRB(50, 0, 50, 25),  
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                      ),
                      elevation: 10,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                          child: ListTile(
                            title: Text('Photo', style: TextStyle( fontSize: 30)),
                            subtitle: Text('Add recipe by scanning',  style: TextStyle( fontSize: 20))
                          ),
                        )
                      )
                    ),
                  ), 
                ] 
              )
            ),
          ]
        );
      }
    }
  )()),
            
        Container(
          margin: EdgeInsets.fromLTRB(280, 650, 0, 0),
          width: 65,
          height: 65,
          child: FloatingActionButton(
            onPressed: (){click();},  
            child:Icon(Icons.add, size: 30,),
            elevation: 15
          )
        )
      ]),
    );
  }
}


