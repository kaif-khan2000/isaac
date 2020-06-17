import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isaac/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:isaac/services/database.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MaterialApp(
    home:Run(),
  ));
}
class Run extends StatefulWidget {
  @override
  _RunState createState() => _RunState();
}

class _RunState extends State<Run> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    return Container(
      child:StreamProvider<QuerySnapshot>.value(
        value:DatabaseServices().doc,
        child: Home(),
      ),
    );
  }
}