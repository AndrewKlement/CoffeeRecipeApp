import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:core';
import 'dart:io';
import 'package:recipe/inventory.dart';

class Addjournal extends StatefulWidget {
  final String itemName;
  final String itemCategory;
  final int duration;
  final List ingredients;
  final String notes;
  final List formatedTimeline;
  final Function synclist;
  Addjournal(this.itemName, this.itemCategory, this.duration, this.ingredients, this.notes, this.formatedTimeline, this.synclist);

  @override
  _AddjournalState createState() => _AddjournalState();
}

class _AddjournalState extends State<Addjournal> {
  List <TextEditingController> question = [TextEditingController()];


  void click(){
    Recipe json;
    List <String>journalquestion = [];
    for(var n in question){
      if(n.text != ''){
        journalquestion.add(n.text);
      }
    }
    json = Recipe(
      widget.itemName, 
      widget.itemCategory, 
      widget.ingredients, 
      widget.duration, 
      widget.notes, 
      widget.formatedTimeline, 
      journalquestion
    );
    save(json);
  }

  void save(Recipe json) async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory dirfolder = Directory('${directory.path}/recipe');
  
    if(await dirfolder.exists()){
      final File file = File('${dirfolder.path}/${widget.itemName}.json');
      await file.writeAsString(jsonEncode(json));
      widget.synclist();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      setState(() {});
    }else{
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder=await dirfolder.create(recursive: true);
      final File file = File('${_appDocDirNewFolder.path}/${widget.itemName}.json');
      await file.writeAsString(jsonEncode(json));
      widget.synclist();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
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
                  'Question',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600, 
                    fontSize: 20
                  ),
                ),

                for(var i in question)
                  Container(
                    width: 260,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(right: 20),
                          child: TextFormField(
                            maxLines: 1, 
                            textInputAction: TextInputAction.next,
                            controller: i,
                            style:TextStyle(
                              color: Colors.black ,
                              fontWeight: FontWeight.w500, 
                              fontSize: 17),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintStyle: TextStyle(
                              color: Colors.black ,
                              fontWeight: FontWeight.w500, 
                              fontSize: 17),
                              hintText:  'Question',
                              prefixText: ' :'
                            ),
                            onTap: (){
                              setState(() {
                                if(question.length-1 == question.indexOf(i)){
                                  question.add(TextEditingController());
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(280, 650, 0, 0),
            width: 65,
            height: 65,
            child: FloatingActionButton(
              onPressed: (){this.click();},  
              child:Icon(Icons.add, size: 30,),
              elevation: 15
            )
          )
        ]
      ),
    );
  }
}