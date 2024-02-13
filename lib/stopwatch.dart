import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recipe/answerjournal.dart';
import 'web.dart';

class StopWatch extends StatefulWidget {
  final List timeline;
  final List journalquestion; 
  final String recipeused;
  final Function bt_send;
  final Function bt_cancel;
  final bool pairState;
  final Function get_value;
  final Function tare;
  
  StopWatch(this.timeline, this.journalquestion, this.recipeused, this.bt_send, this.bt_cancel, this.pairState, this.get_value, this.tare);
  
  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  Stopwatch _stopwatch;
  Timer _timer;
  List allPoint = [];
  String second;
  PageController page = PageController();
  bool finish = false;
  bool send_recipe_count = false;

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs ~/ 60)% 60 ).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    second = secs.toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  get_ScaleValue(){
    return '{"type": "recipe", "data": "${widget.get_value().toString()}"}';
  }

  get_TimeandWeight(){
    List retrun_val = ['["0", "0"]'];
    int counter = 0;
    for (var i = 0; i < widget.timeline.length-1; i++) {
      String weight =  widget.timeline[i][1].replaceAll(new RegExp(r'[^0-9]'),'');
      if(i == widget.timeline.length-1){
        retrun_val.add('["${widget.timeline[i+1][0]}", "${counter.toString()}"]');
      }
      else if(weight != '' && i != 0){
        int value =  ((int.parse(weight)) + counter);
        retrun_val.add('["${widget.timeline[i+1][0]}", "${value.toString()}"]');
        counter = value;
      }
      else if(weight != '' && i == 0){
        retrun_val.add('["${widget.timeline[i+1][0]}", "${weight}"]');
        counter += int.parse(weight);
      }
    }
    print(retrun_val);
    recipe_timeline = '{"type": "recipe", "data": ${retrun_val.toString()}}';
  }

  @override
  void initState() {
    super.initState();
    get_TimeandWeight();
    print(recipe_timeline);
    for(var i in widget.timeline){
      allPoint.add(i[0]);
    }
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(Duration(milliseconds: 5), (timer) {
      if(finish){
        _stopwatch.stop();
        _timer.cancel;
      }else{
        scale_value = get_ScaleValue();
        if(allPoint.contains(second)){
          changepage(page.page.toInt()+1);
        }
      }
      setState(() {});
    }); 
  }

  
  @override
  void dispose() {
    _timer.cancel();
    page.dispose();
    super.dispose();
  }

  void handleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
      setState(() {});
    }
  }

  void changepage(index){
    page.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: 260,
            margin: EdgeInsets.fromLTRB(50, 70, 0, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 260,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Text(
                          '${formatTime(_stopwatch.elapsedMilliseconds)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600, 
                            fontSize: 50
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),

                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Timeline',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600, 
                      fontSize: 20
                    ),
                  ),
                ),
                
                Container(
                  height: 300,
                  margin: EdgeInsets.only(top: 20),
                  child: PageView.builder(
                    physics: BouncingScrollPhysics(),
                    controller: page,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.timeline.length,
                    onPageChanged: (value){
                      print(value);
                    },
                    itemBuilder: (context, index){
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                              child: Container(
                                height: 210,
                                child:  SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                      child: Text(
                                      widget.timeline[index][1].toString(),
                                      style: TextStyle(
                                        color: Colors.black ,
                                        fontWeight: FontWeight.w500, 
                                        fontSize: 17),
                                    ),
                                  )
                                ),
                              )
                            ),
                            Container(
                              height: 50,
                              width: 260,
                              margin: EdgeInsets.only(
                                top: 17
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade300,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                )
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 15
                                    ),
                                    child: Text(
                                      '$index/${widget.timeline.length-1}',
                                      style: TextStyle(
                                        color: Colors.black ,
                                        fontWeight: FontWeight.w500, 
                                        fontSize: 17
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    width: 180,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        physics: BouncingScrollPhysics(),
                                        child: Text(
                                          '${((){
                                            if(widget.timeline.length-1 != index){
                                              finish = false;
                                              if(int.parse(widget.timeline[index+1][0])-int.parse(second) < 0){
                                                return '0s';
                                              }
                                              if(int.parse(widget.timeline[index+1][0])-int.parse(second) != -1){
                                               return '${int.parse(widget.timeline[index+1][0])-int.parse(second)}s';
                                              }
                                            }
                                            else{
                                              finish = true;
                                              return 'Finish';
                                            }
                                          }())}',
                                          style: TextStyle(
                                            color: Colors.black ,
                                            fontWeight: FontWeight.w500, 
                                            fontSize: 17
                                          ),
                                        ),
                                      )
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      );
                    }
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(finish){
                      if(widget.pairState == true){
                        stopServer();
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (context) => (Test(widget.journalquestion, widget.recipeused))));
                    }
                    else{
                      handleStartStop();
                    }
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
                            ((){
                             if(finish){
                               return 'Continue';
                             }
                             else{
                              if( _stopwatch.isRunning){
                                return 'Stop';
                              }
                              else{
                                return 'Start';
                              }
                             }
                            }()),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700, 
                              fontSize: 23),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Transform.scale(
                            scale: 1.2,
                            child: Icon(
                              ((){
                                if(finish){
                                  return Icons.arrow_forward;
                                }
                                else{
                                  if( _stopwatch.isRunning){
                                    return Icons.stop;
                                  }
                                  else{
                                    return Icons.play_arrow;
                                  }
                                }
                              }())
                            )
                          )
                        )
                      ],
                    )
                  ),
                )
              ]
            )
          )
        ]
      )
    );
  }
}