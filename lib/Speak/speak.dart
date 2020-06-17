import 'package:flutter_tts/flutter_tts.dart';

class Speak {
  FlutterTts flutterTts = FlutterTts();
  Future speak(String response)async{
    await flutterTts.setLanguage("en-us");
    await flutterTts.setVoice("kn-in-x-knm-network");
    await flutterTts.setSpeechRate(1);
    await flutterTts.setVolume(25);
    await flutterTts.setPitch(1);
    await flutterTts.speak(response);
  }
   
}