import 'package:flutter/material.dart';
import 'package:recipe/addjournal.dart';

class Newtimeline extends StatefulWidget {
  final String itemName;
  final String itemCategory;
  final int duration;
  final List ingredients;
  final String notes;
  final Function synclist;
  Newtimeline(this.itemName, this.itemCategory, this.duration, this.ingredients, this.notes, this.synclist);

  @override
  _NewtimelineState createState() => _NewtimelineState();
}

class _NewtimelineState extends State<Newtimeline> {
  List <List<TextEditingController>>timeline = [[TextEditingController(), TextEditingController()]];
  
  
  void dispose(){
    for(var i in timeline){
      i[0].dispose();
      i[1].dispose();
    }
    super.dispose();
  }

  void click(){
    List formatedTimeline = [];
    for(var i in timeline){
      if(i[0].text != '' || i[1].text != ''){
        formatedTimeline.add([i[0].text, i[1].text]);
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => Addjournal(
      widget.itemName, 
      widget.itemCategory, 
      widget.duration, 
      widget.ingredients, 
      widget.notes, 
      formatedTimeline,
      widget.synclist
    )));
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
                Row(
                  children: [
                    Container(
                      width: 130,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Text(
                          '${widget.duration} S',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600, 
                            fontSize: 25
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 130,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade300,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      )
                    )
                  ],
                ),

                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),

                Text(
                  'Timeline',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600, 
                    fontSize: 20
                  ),
                ),

                for(var i in timeline)
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
                            keyboardType: TextInputType.number,
                            maxLines: 1, 
                            textInputAction: TextInputAction.newline,
                            controller: i[0],
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
                              hintText:'At :',
                              suffixText: 'Second', 
                            ),
                            onTap: (){
                              setState(() {
                                if(timeline.length-1 == timeline.indexOf(i)){
                                  timeline.add([TextEditingController(), TextEditingController()]);
                                }
                              });
                            },
                          ),
                        ),

                        Container(
                          width: 200,
                          margin: EdgeInsets.fromLTRB(0, 0, 20, 20),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null, 
                            textInputAction: TextInputAction.newline,
                            controller: i[1],
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
                              hintText:'Instruction', 
                            )
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
      )
    );
  }
}