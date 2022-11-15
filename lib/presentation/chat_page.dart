import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:evolt_test/const.dart';

import 'package:evolt_test/firebase/authentication.dart';
import 'package:evolt_test/firebase/chat.dart';
import 'package:evolt_test/firebase/stream_firebase.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

String token = '';

class _ChatPageState extends State<ChatPage> {
  getUserId() async {
    String? id = await Authentication.checkLoginStatus();
    token = id!;
  }

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: StreamBuilder(
        stream: StreamFirebaseFireStore.chat,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data != null) {
            return ListView.builder(
                reverse: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot<Map<String, dynamic>> messageInfo =
                      snapshot.data!.docs[index];

                  return Container(
                    alignment: messageInfo['id'] == userID
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    child: Container(
                        decoration: BoxDecoration(
                            color: messageInfo['id'] == userID
                                ? Colors.blue
                                : Colors.black,
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 14),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        child: Column(
                          children: [
                            Text(
                              messageInfo['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              messageInfo['message'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              messageInfo['date'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        )),
                  );
                });
          } else {
            return const Center(
              child: Text(
                'No Internet Connection',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }
        },
      )),
      bottomNavigationBar: Container(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 20, bottom: 10),
          child: ListTile(
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(12)),
              child: TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Type Message',
                  border: InputBorder.none,
                ),
              ),
            ),
            trailing: InkWell(
              onTap: () {
                Chat.sendGroupMessage(messageController.text);
                messageController.clear();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SvgPicture.asset(
                  'assets/send.svg',
                  height: 30,
                  width: 30,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
