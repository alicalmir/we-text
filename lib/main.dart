import 'package:device_preview/device_preview.dart';
import 'package:evolt_test/presentation/autcheker_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:evolt_test/firebase/notification.dart';
import 'package:evolt_test/firebase/authentication.dart';
import 'package:evolt_test/firebase/chat.dart';
import 'package:evolt_test/presentation/homepage.dart';
import 'package:evolt_test/presentation/register_user.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Global Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthChecker());
  }
}
