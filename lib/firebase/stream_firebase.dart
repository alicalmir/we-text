import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evolt_test/const.dart';

class StreamFirebaseFireStore {
  /// list of users
  static Stream<QuerySnapshot<Map<String, dynamic>>> get userList => fireStore
      .collection('users')
      .orderBy('name', descending: false)
      .snapshots();

  //this function get  group messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> get chat => fireStore
      .collection('message')
      .orderBy('date', descending: true)
      .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> chatOneToOne(
      String receiverID) {
    final chatData = fireStore
        .collection('Personal Chat')
        .doc(receiverID)
        .collection('chat')
        .orderBy('time', descending: true)
        .snapshots();
    return chatData;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> chatList() {
    final chatData = fireStore
        .collection('ChatList')
        .doc(userID)
        .collection('messagesList')
        .orderBy('time', descending: true)
        .snapshots();
    return chatData;
  }
}
