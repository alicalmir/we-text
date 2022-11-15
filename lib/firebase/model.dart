import 'package:cloud_firestore/cloud_firestore.dart';

class SendMessageModel {
  final String name;
  final String message;
  final String id;
  final String date;

  SendMessageModel({
    required this.name,
    required this.message,
    required this.id,
    required this.date,
  });

  factory SendMessageModel.fromSnapShot(DocumentSnapshot snapShot) {
    return SendMessageModel(
      name: (snapShot.data()! as dynamic)['name'],
      message: (snapShot.data()! as dynamic)['message'],
      id: (snapShot.data()! as dynamic)['id'],
      date: (snapShot.data()! as dynamic)['date']
    );
  }

  Map<String, dynamic> toJson()=>{
    'name':name,
    'message':message,
    'id':id,
    'date':date
  };
}
