import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:core';
import 'package:recipe/inventory.dart';
import 'dart:convert';
import 'package:recipe/rating.dart';

class Journallist extends StatefulWidget {

  @override
  _JournallistState createState() => _JournallistState();
}

class _JournallistState extends State<Journallist> {
  List journalPath = [];
  List <Journal> journalJson = [];
  List <bool> tapContainer = [];
  
  void initState(){  
    syncList();
    super.initState();
  }

  void syncList() async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory dirfol = Directory('${directory.path}/journal');
    if(await dirfol.exists() == false){
      await dirfol.create(recursive: true);
    }
    setState(() {
      journalPath = dirfol.listSync();
      journalJson = [];
      tapContainer = [];
      for(var i in journalPath){
        journalJson.add(Journal.fromJson(jsonDecode(i.readAsStringSync())));
        tapContainer.add(false);
      }
      print(journalPath);
    });
  } 

  journalWidget(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: 260,
        margin: EdgeInsets.fromLTRB(50, 50, 0, 0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                width: 130,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Text(
                    'Journal',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600, 
                      fontSize: 25
                    ),
                  ),
                ),
              ),

              Divider(
                color: Colors.black,
                thickness: 1,
              ),

              Text(
                'List of journal',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600, 
                  fontSize: 20
                ),
              ),

              for (var i = 0; i < journalPath.length; i++)
                Container(
                  width: 260,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 190,
                            margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                            child: Text(
                              journalJson[i].recipeused,
                              style: TextStyle(
                                color: Colors.black ,
                                fontWeight: FontWeight.w500, 
                                fontSize: 17
                              ),
                            ),
                          ),
                          Container(
                            child: IconButton(
                              onPressed: (){
                                journalPath[i].deleteSync();
                                tapContainer.removeAt(i);
                                syncList();
                              }, 
                              icon: Icon(Icons.close)
                            )
                          )
                        ],
                      ),

                      if(!tapContainer[i])
                        Container(
                          width: 190,
                          margin: EdgeInsets.fromLTRB(0, 0, 30, 10),
                          child: StarRating(
                            rating: journalJson[i].rating,
                          )
                        ),

                      if(tapContainer[i])
                        Container(
                          width: 190,
                          margin: EdgeInsets.fromLTRB(0, 0, 30, 10),
                          child: Text(
                            'Date : ${journalJson[i].date.substring(0,16)}',
                            style: TextStyle(
                              color: Colors.black ,
                              fontWeight: FontWeight.w500, 
                              fontSize: 17
                            ),
                          ),
                        ),

                      if(tapContainer[i])
                        for (var x = 0; x < journalJson[i].journalquestion.length; x++)
                          Container(
                            width: 190,
                            margin: EdgeInsets.fromLTRB(0, 0, 30, 10),
                            child: Text(
                            '${journalJson[i].journalquestion[x]} : ${journalJson[i].journalanswer[x]}',
                            style: TextStyle(
                              color: Colors.black ,
                              fontWeight: FontWeight.w500, 
                              fontSize: 17
                            ),
                          ),
                        )
                      ,

                      if(tapContainer[i])
                        Container(
                          width: 190,
                          margin: EdgeInsets.fromLTRB(0, 0, 30, 10),
                          child: Text(
                            'Notes : ${journalJson[i].notes}',
                            style: TextStyle(
                              color: Colors.black ,
                              fontWeight: FontWeight.w500, 
                              fontSize: 17
                            ),
                          ),
                        )
                      ,

                      if(tapContainer[i])
                        Container(
                          width: 190,
                          margin: EdgeInsets.fromLTRB(0, 0, 30, 10),
                          child: StarRating(
                            rating: journalJson[i].rating,
                          )
                        )
                      ,

                      IconButton(
                        onPressed: (){
                          if(tapContainer[i] == false){
                            tapContainer[i] = true;
                          }
                          else{
                            tapContainer[i] = false;
                          }
                          setState(() {});
                        }, 
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                        splashRadius: null ,
                      ),
                    ],
                  ),
                ),
              ],
            ),
      )
    );
  }
}