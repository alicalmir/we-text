import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time/date_time.dart';
import 'package:evolt_test/const.dart';
import 'package:evolt_test/firebase/model.dart';
import 'package:evolt_test/firebase/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat {
  static sendGroupMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    final data = await fireStore.collection('users').doc(id).get();
    final userData = (data.data()! as dynamic)['name'];

    SendMessageModel sendMessage = SendMessageModel(
        name: userData,
        message: message,
        id: id!,
        date: DateTime.now().time.format(TimeStringFormat.HHmm));

    await fireStore.collection('message').add(sendMessage.toJson());
    // await sendNotificationToGroup(title: 'Group Message', body:message );
  }

  ///ONE TO ONE CHAT
  static onetooneChat({
    required String message,
    required String receiverUID,
    required String receiverName,
    required String receivertoken,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    String? id = prefs.getString('id');
    String? name = prefs.getString('name');
    String? sendertoken = await firebaseMessaging.getToken();
    Map<String, dynamic> messageMap = {
      'sender': name,
      'message': message,
      'id': id,
      'time': FieldValue.serverTimestamp(),
    };
    Map<String, dynamic> senderchatList = {
      'receiver': receiverName,
      'lastmessage': message,
      'time': FieldValue.serverTimestamp(),
      'id': receiverUID,
      'token': receivertoken
    };

    Map<String, dynamic> receiverchatList = {
      'receiver': name,
      'lastmessage': message,
      'time': FieldValue.serverTimestamp(),
      'id': id,
      'token': sendertoken
    };
    // send message to user database
    await fireStore
        .collection('Personal Chat')
        .doc(id)
        .collection('chat')
        .add(messageMap);
    // send message to receiver database
    await fireStore
        .collection('Personal Chat')
        .doc(receiverUID)
        .collection('chat')
        .add(messageMap);

    ///create a chatList  for  user sending the message
    await fireStore
        .collection('ChatList')
        .doc(id)
        .collection('messagesList')
        .doc(receiverUID)
        .set(senderchatList);

    // create a chatList for receiver of message
    await fireStore
        .collection('ChatList')
        .doc(receiverUID)
        .collection('messagesList')
        .doc(id)
        .set(receiverchatList);

    /// push notification
    await PushNoti.sendNotification(
        token: receivertoken, title: 'New message from $name', body: message);
  }

//Make user onlone or Offline
  static void makeUserOnline({required bool status}) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('id');
    await fireStore.collection('users').doc(uid).update({'status': status});
  }
}
