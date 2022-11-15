import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:evolt_test/const.dart';
import 'package:evolt_test/firebase/notification.dart';
import 'package:evolt_test/presentation/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Authentication {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static Future saveUser(BuildContext context) async {
    try {
      final nav = Navigator.of(context);
      String uid = const Uuid().v1();
      String? token = await firebaseMessaging.getToken();
      String randomName = generateRandomString(6);
      final prefs = await SharedPreferences.getInstance();
      await firebaseMessaging.subscribeToTopic('group');
      await prefs.setString('id', uid);
      await prefs.setString('name', randomName);
      await fireStore
          .collection('users')
          .doc(uid)
          .set({'name': randomName, 'id': uid, 'status': true, 'token': token});
      await PushNoti.sendNotificationToGroup(
          title: 'New User', body: "$randomName has joined");

      nav.push(MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      print(e);
    }
  }

  /// Generates random username
  static String generateRandomString(int len) {
    var r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

////  get token
  static Future<String?> checkLoginStatus() async {
    String token = '';
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('id');
    if (value == null) {
      token = '';
    } else if (value.isNotEmpty) {
      token = value;
    }

    return token;
  }
}
