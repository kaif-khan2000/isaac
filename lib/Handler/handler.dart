import 'package:device_apps/device_apps.dart';
import 'package:isaac/Speak/speak.dart';
import 'package:dartpedia/dartpedia.dart' as wiki;
import 'package:firebase_database/firebase_database.dart';
class Handler {
  

  Speak speakController = Speak();
  Future handler(String resultText,dynamic docList) async {
    String actual = resultText;
    final databaseReference = FirebaseDatabase.instance.reference();
    if(resultText != null){
      resultText = textFormatter(resultText);
      resultText = resultText.toLowerCase();
      List resultList = resultText.split(" ");
      int count = 0;
      
      if("launch" == resultList[0]){
        launchApp(resultList, docList);
        count++;
        return false;

      }else{
        String response;
        try{
          await databaseReference.child(actual).once().then((snapshot){
            response = snapshot.value["response"];
            print("$response response");
          });
          print("response:$response");
          if(response != null){
            speakController.speak(response);
            return false;
          }
        }catch(e){
          print(count);
          speakController.speak("I dont know what you are saying. Do you Want me to learn this");
          return true;
        }
      }

    }
  }
  bool isIn(String check,String parent){
    return parent.split(" ").contains(check);
  }
  String textFormatter(String text){
    text = text.replaceAll('\'s', ' is');
    text = text.replaceAll('\'nt', ' not');
    text = text.replaceAll(' isaac',"");
    text = text.replaceAll('isaac ', '');
    text = text.replaceAll('Isaac ', '');
    text = text.replaceAll(' Isaac', '');
    return text;
  }
  void launchApp(List app,dynamic docList){
    for(var doc in docList.documents){
      if(app.contains(doc.data["name"])){
        DeviceApps.openApp(doc.data['package'].toString());
        speakController.speak(doc.data["name"]);
      }
    }
  }
}