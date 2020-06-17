
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class ComputerControl extends StatefulWidget {
  @override
  _ComputerControlState createState() => _ComputerControlState();
}

class _ComputerControlState extends State<ComputerControl> {
  Socket socket;
  List<Widget> chat = List<Widget>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSocket();  
  }
  void initSocket() async {
    socket = await Socket.connect('192.168.0.108',5111);
    socket.add(utf8.encode("i am here"));
    socket.listen((event) {
      setState(() {
        
        chat.add(
          Message(from: "comp",message: String.fromCharCodes(event).trim(),)
        );
      });
    });
  }

  void toggle(bool tog){
    setState(() {
      switchControl = tog;
    });
  }

  bool switchControl = false;

  TextEditingController messageController = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Computer Control"),
        actions: [
          Switch(
            onChanged: toggle,
            value: switchControl,
            activeColor: Colors.red[500],
          ),
        ],
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                ...chat,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                switchControl?Text("\$:",
                  style: TextStyle(
                    color: Colors.green[500],
                    fontSize: 30,
                  ),
                ):Text(""),
                SizedBox(width: 10,),
                Expanded(
                  child: TextField(
                    cursorColor: switchControl?Colors.green[500]:Colors.white,
                    style: TextStyle(
                      color: switchControl?Colors.green:Colors.white,
                    ),
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: switchControl?" Enter Unix Command":"Enter your message",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      
                    ),
                  ),
                ),
                IconButton(
                  color: Colors.red,
                  icon:Icon(Icons.send),
                  onPressed:(){
                    String totalMsg;
                    if(messageController.text.length > 0){
                      totalMsg = (switchControl?"\$: ":"")+messageController.text;
                      setState(() {
                        chat.add(
                          Message(message:totalMsg,from:"me")
                        );
                      });
                      socket.add(utf8.encode(totalMsg));
                      messageController.clear();
                      scrollController.animateTo(
                        10000000000, 
                        duration: Duration(milliseconds: 300), 
                        curve: Curves.easeOut,
                      );
                      socket.listen((event) {
                        setState(() {
                          chat.add(
                            Message(message:String.fromCharCodes(event).trim(),from:"comp")
                          );
                        });
                      });
                    }
                  }
                ),
              ],  
            ),
          ),
        ],
      ),
    );
  }
}


class Message extends StatelessWidget {
  String message;
  String from;
  Message({this.message,this.from});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8,0),
      child: Column(
        crossAxisAlignment: (from == "me")? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            color: (from == "me")?Colors.blue[400]:Colors.red[500],
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6,
            child: Container(
              padding: EdgeInsets.symmetric(vertical:10,horizontal:20),
              child: Text(
                message,
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}