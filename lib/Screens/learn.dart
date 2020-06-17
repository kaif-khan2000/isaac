import 'package:flutter/material.dart';
import 'package:isaac/Speak/speak.dart';
import '../main.dart';
import 'package:firebase_database/firebase_database.dart';

class Learn extends StatefulWidget {
  String statement;
  Learn({this.statement});
  @override
  _LearnState createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  String response = '';
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("learn"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("learn:${widget.statement}"),
              SizedBox(height: 100,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter the response",
                  filled: true,
                  labelText: "Response",
                  border: UnderlineInputBorder(),
                ),
                onChanged: (String value){
                  setState(() {
                    response = value;
                  });
                },
                validator: (response){
                  if(response.isEmpty){
                    return "type in a response";
                  }
                  return null;
                },
              ),
              RaisedButton(
                child: Text("Learn"),
                onPressed: () async {
                  if(_formKey.currentState.validate() && widget.statement.isNotEmpty){
                    await databaseReference.child(widget.statement).set({
                      "question":widget.statement,
                      "response":response,
                    });
                    Speak().speak("I have learnt it very well");
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context)=>Run(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}