import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isaac/Handler/handler.dart';
import 'package:isaac/Screens/computer_control.dart';
import 'package:isaac/Screens/learn.dart';
import 'package:provider/provider.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  String resultText = "";
  String totalText = "";
  dynamic docList;
  dynamic learn = false;
  String lastCommand = "";

  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();

  }
  
  Future initSpeechRecognizer()async{
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler((result) {
      setState(() {
        _isAvailable = result;
      });
    });
    _speechRecognition.setRecognitionStartedHandler(() {
      setState(() {
        
        _isListening = true;
      });
    });
    _speechRecognition.setRecognitionResultHandler((text) {
      print(text);
      setState(() {
        resultText = text;
      });
    });
    _speechRecognition.setRecognitionCompleteHandler(()async{
      
      bool res = await Handler().handler(resultText,docList);
      print('res:$res');
      if(res!=null){
        setState(() {
          learn = res;
          if(resultText!="") lastCommand = resultText;
          resultText = '';
        });
      }
    });
    _speechRecognition.activate().then(
      (result){
        setState(() {
          _isAvailable = result;
        });
      }
    );
  }
  
  void listen(){
    _speechRecognition.listen(locale: 'en_us').then((result) => print('$result'));
  }


  @override
  Widget build(BuildContext context) {
    if(_isListening){
      print("build:"+resultText);
    }
    setState(() {
      _isListening = false;
      docList = Provider.of<QuerySnapshot>(context);
    });

    return learn ? Learn(statement: lastCommand) : Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if( !_isListening){
            listen();
          } 
        },
        child: Icon(
          Icons.mic,
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              child: Text(resultText),
            ),
          ),
          RaisedButton(
            child: Text("Computer"),
            onPressed: (){
              Navigator.push(context,MaterialPageRoute(
                builder: (context) => ComputerControl(),
              ));
            },
          ),
        ],
      ),
    );
  }
}

