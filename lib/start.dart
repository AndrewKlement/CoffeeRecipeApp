import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'inventory.dart';
import 'dart:convert';
import 'stopwatch.dart';
import 'web.dart';

class Prep extends StatefulWidget {
  final String json; 
  final bool pairState;
  final BluetoothConnection connection;
  StreamSubscription bt_stream;
  final Function bt_send;
  final Function bt_cancel;
  final Function get_value;
  final Function tare; 

  Prep(this.json, this.pairState, this.connection, this.bt_stream, this.bt_send, this.bt_cancel, this.get_value, this.tare);

  @override
  _PrepState createState() => _PrepState();
}

class _PrepState extends State<Prep> {
  Recipe recipe ;
  List<bool> check = [];
  bool use_scale = false;
  Timer update_value;
  String live_value;

  void initState(){
    recipe = Recipe.fromJson(jsonDecode(widget.json));
    for (var i = 0; i < recipe.ingredients.length; i++) {
      check.add(false);
    }
    if(widget.pairState == true){
      widget.bt_send('start');
      update_value = new Timer.periodic(new Duration(milliseconds: 10), (timer) {
        live_value = widget.get_value();
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if(update_value != null){
      update_value.cancel();  
    }
    super.dispose();
  }

  build_ScaleControl(){
    if(widget.pairState){
        return <Widget> [
          Text(
            'Scale Control',
            style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600, 
            fontSize: 20),
          ),
          Divider(
            color: Colors.black,
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child : Text(
              '${live_value == null ? 'No Weight' : '$live_value gr'}',
              style:TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500, 
              fontSize: 18),
            ),
          ),
          GestureDetector(
            onTap: (){
              widget.bt_send('tare');
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
              color: Colors.blue.shade300.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(13))
              ),
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Row(
                children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Transform.scale(
                      scale: 0.7,
                      child: Icon(Icons.replay, color: Colors.blue.shade400,)
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Text(
                    'Tare',
                    style: TextStyle(
                    color: Colors.blue.shade400,
                    fontWeight: FontWeight.w500, 
                    fontSize: 20),
                  ),
                ),
              ],
            )
          ),
        ),
        GestureDetector(
            onTap: (){
              widget.bt_send('calibrate');
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
              color: Colors.blue.shade300.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(13))
              ),
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Row(
                children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Transform.scale(
                      scale: 0.7,
                      child: Icon(Icons.scale, color: Colors.blue.shade400,)
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Text(
                    'Calibrate',
                    style: TextStyle(
                    color: Colors.blue.shade400,
                    fontWeight: FontWeight.w500, 
                    fontSize: 20),
                  ),
                ),
              ],
            )
          ),
        ),
      Divider(
        color: Colors.black,
        thickness: 1,
      )
    ];
    }
    else{
      return <Widget> [Container()];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:<Widget> [
          Container(
            width: 260,
            margin: EdgeInsets.fromLTRB(50, 50, 0, 0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Text(
                  '${recipe.itemName}',                
                  style:TextStyle(
                  color: Colors.black ,
                  fontWeight: FontWeight.w700, 
                  fontSize: 25),
                ),

                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),

                Text(
                  '${recipe.itemCategory}',
                  style:TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600, 
                  fontSize: 20),
                ),

                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),

                Text(
                  '${recipe.duration}',
                  style:TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600, 
                  fontSize: 20),
                ),

                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),

               Container(
                height: 200,
                child:ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: recipe.ingredients.length,
                  itemBuilder: (context, index){
                    return Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Checkbox(
                            value: check[index],
                            onChanged: (value){
                              check[index] = value;
                              setState(() {});
                            },
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            '${recipe.ingredients[index]}',
                            style:TextStyle(fontWeight: FontWeight.w500,
                            color: Colors.black, 
                            fontSize: 20),
                          ),
                        )
                      ],
                    );
                  }
                ),
               ),
                Text(
                  'Notes',
                  style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600, 
                  fontSize: 20),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                Text(
                  '${recipe.notes}',
                  style:TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600, 
                  fontSize: 18),
                ),

                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),

                Container(margin: EdgeInsets.fromLTRB(0, 30, 0, 0),),

                ...build_ScaleControl(),

                GestureDetector(
                  onTap: (){
                    if(widget.pairState){
                      startServer();
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => (
                      StopWatch(recipe.timeline, recipe.journalquestion, recipe.itemName, widget.bt_send, widget.bt_cancel, widget.pairState, widget.get_value, widget.tare)
                      )
                    ));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    margin: EdgeInsets.only(top: 60),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700, 
                              fontSize: 23),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Transform.scale(
                            scale: 0.7,
                            child: Icon(Icons.arrow_forward_ios_rounded)
                          )
                        )
                      ],
                    )
                  ),
                ),

                Container(margin: EdgeInsets.fromLTRB(0, 70, 0, 0),),
              ],
            ),
          ),
        ]
      ) ,
    );
  }
}