import 'package:flutter/material.dart';
import 'package:recipe/inventory.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:core';
import 'dart:io';
import 'dart:convert';

class StarRating extends StatelessWidget {
  final int starCount;
  final int rating;
  final Function onRatingChanged;
  final Color color;
  final double size;
  StarRating({this.starCount = 5, this.rating = 0, this.onRatingChanged, this.color, this.size = 30});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Colors.black,
        size: size,
      );
    }else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    }
    return new GestureDetector(
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index+1),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}

class Test extends StatefulWidget {
  final List journalquestion;
  final String recipeused;
   Test(this.journalquestion, this.recipeused);

  @override
  _TestState createState() => new _TestState();
}

class _TestState extends State<Test> {
  int rating = 3;
  TextEditingController notes = TextEditingController();
  List <TextEditingController> journalController = []; 

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.journalquestion.length; i++) {
      journalController.add(TextEditingController());
    }  
  }

  void save(Journal json, dateTime) async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory dirfolder = Directory('${directory.path}/journal');
  
    if(await dirfolder.exists()){
      final File file = File('${dirfolder.path}/$dateTime.json');
      await file.writeAsString(jsonEncode(json));
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      setState(() {});
    }else{
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder=await dirfolder.create(recursive: true);
      final File file = File('${_appDocDirNewFolder.path}/$dateTime.json');
      await file.writeAsString(jsonEncode(json));
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Stack(
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


                for(var i = 0; i < widget.journalquestion.length; i++)
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.journalquestion[i].toString(),
                          style:TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black, 
                            fontSize: 20
                          ),
                        ),
                      ),
                      
                      Container(
                        child: TextFormField(
                          maxLines: null, 
                          textInputAction: TextInputAction.next,
                          controller: journalController[i],
                          style:TextStyle(
                            color: Colors.black ,
                            fontWeight: FontWeight.w500, 
                            fontSize: 17),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(      
                                borderSide: BorderSide(color: Colors.black),   
                              ),  
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black ,
                              fontWeight: FontWeight.w500, 
                              fontSize: 17
                            ),
                            hintText:  'Answer',
                            ),
                          ),
                        )
                      ]
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Notes',
                      style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600, 
                      fontSize: 20),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null, 
                    textInputAction: TextInputAction.newline,
                    controller: notes,
                    style:TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600, 
                    fontSize: 18),
                    decoration: InputDecoration(        
                    enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.black),   
                    ),  
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400, 
                    fontSize: 18),
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    hintText: ''),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: StarRating(
                      rating: rating,
                      onRatingChanged: (rating) => setState(() => this.rating = rating),
                    ),
                  )
              ],
            )
          ),
      
          Container(
            margin: EdgeInsets.fromLTRB(280, 650, 0, 0),
            width: 65,
            height: 65,
              child: FloatingActionButton(
                onPressed: (){
                  DateTime now = new DateTime.now();
                  List journalanswer = [];
                  for (var i in journalController) {
                    journalanswer.add(i.text);
                  }
                  Journal journal = Journal(rating, widget.recipeused, now.toString(), widget.journalquestion, journalanswer, notes.text);
                  save(journal, now);
                },  
                child:Icon(Icons.add, size: 30,),
                elevation: 15
              )
            )
          ],
        ),
      );
  }
}