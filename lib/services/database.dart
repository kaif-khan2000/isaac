import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseServices{
  CollectionReference collection = Firestore.instance.collection("history");
  Stream<QuerySnapshot> get doc {
    return collection.snapshots();
  }
}