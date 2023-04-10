import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNoti {
  /// initialize firebase push notification
  static push() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  static sendNotificationToGroup({
    required String title,
    required String body,
  }) async {
//server key
    var serverToken =
        'key=AAAA1-Dpwgg:APA91bEZQ1RwLKlCtYj8QXH36jtDbm6ptE8pqpaz5lRN1LSPzmhpFuYdWFO09J_0IZw8rxquvItzzdwdqagqa6RftpmLzQ0b_yWLt-B3nLSc_ZgMmZdRAijPCvzUt5o1X4kZdD3906__';

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };
    Map notificationMap = {
      "body": body,
      "title": title,
    };

    Map sendNotificationMap = {
      "topic": 'group',
      'notification': notificationMap,
      "priority": "high",
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      },
    };
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
  }

  static sendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    //server key here
    var serverToken =
        'key=AAAA1-Dpwgg:APA91bEZQ1RwLKlCtYj8QXH36jtDbm6ptE8pqpaz5lRN1LSPzmhpFuYdWFO09J_0IZw8rxquvItzzdwdqagqa6RftpmLzQ0b_yWLt-B3nLSc_ZgMmZdRAijPCvzUt5o1X4kZdD3906__';

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };
    Map notificationMap = {
      "body": body,
      "title": title,
    };

    Map sendNotificationMap = {
      "to": token,
      'notification': notificationMap,
      "priority": "high",
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      },
    };
    var notif = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
    if (notif.statusCode == 200) {
      print('............Sent...... succes');
    } else {
      print('.......status code ${notif.statusCode}.....');
    }
  }
}
