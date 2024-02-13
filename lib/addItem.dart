import 'package:flutter/material.dart';
import 'addtimeline.dart';

class NewItem extends StatefulWidget {
  final Function synclist;

  NewItem(this.synclist);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  TextEditingController recipename = TextEditingController();
  TextEditingController catagory =  TextEditingController();
  TextEditingController duration =  TextEditingController();
  TextEditingController notes =  TextEditingController();
  List<TextEditingController> ingredients = [TextEditingController()];
  
  void dispose() {
    recipename.dispose();
    catagory.dispose();
    duration.dispose();
    notes.dispose();
    for(var i in ingredients){
      i.dispose();
    }
    super.dispose();
  }

  void click(){
    FocusScope.of(context).unfocus();
    List <String> strIngredients = [];
    for(var i in ingredients){
      if(i.text != ''){
       strIngredients.add(i.text);
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => Newtimeline(
      recipename.text,
      catagory.text,
      int.tryParse(duration.text),
      strIngredients,
      notes.text,
      widget.synclist
    )));
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
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null, 
                  textInputAction: TextInputAction.newline,
                  controller: recipename,
                  style:TextStyle(
                  color: Colors.black ,
                  fontWeight: FontWeight.w700, 
                  fontSize: 25),
                  decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700, 
                  fontSize: 25),
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  hintText: 'Recipe Name'),
                ),

                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),

                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null, 
                  textInputAction: TextInputAction.newline,
                  controller: catagory,
                  style:TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600, 
                  fontSize: 20),
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
                  fontWeight: FontWeight.w600, 
                  fontSize: 20),
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  hintText: 'Catagory'),
                ),

                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLines: null, 
                  textInputAction: TextInputAction.newline,
                  controller: duration,
                  style:TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600, 
                  fontSize: 20),
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
                  fontWeight: FontWeight.w600, 
                  fontSize: 20),
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  suffixText: 'Second',
                  hintText: '0'
                  ),
                ),

               Container(
                height: 200,
                child:ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index){
                    return Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Checkbox(
                            value: true,
                            onChanged: (value){},
                          ),
                        ),
                        Container(
                          width: 200,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            controller: ingredients[index],
                            style:TextStyle(fontWeight: FontWeight.w500,
                            color: Colors.black, 
                            fontSize: 20),
                            decoration:  InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500, 
                            fontSize: 20),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            hintText: 'Ingredients'),
                            onTap: (){
                              setState(() {
                                if(ingredients.length-1 == index){
                                  ingredients.add(TextEditingController());
                                }
                              });
                            },
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