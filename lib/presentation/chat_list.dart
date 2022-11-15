import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:evolt_test/firebase/stream_firebase.dart';
import 'package:evolt_test/presentation/one_to_one.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

String userId = '';

class _UsersListState extends State<UsersList> {
  getname() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? name = pref.getString('name');
    setState(() {
      userId = name!;
    });
  }

  @override
  void initState() {
    super.initState();
    getname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: StreamBuilder(
        stream: StreamFirebaseFireStore.chatList(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /*
      User A 0
      USER B 1
      USER C 2
      USER D 3
          */
          if (snapshot.data != null) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot<Map<String, dynamic>> messageInfo =
                      snapshot.data!.docs[index];
                  return Container(
                    alignment: Alignment.centerLeft,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          tileColor: Color.fromARGB(255, 60, 59, 59),
                          style: ListTileStyle.list,
                          title: Text(
                            messageInfo['receiver'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          subtitle: Text(
                            messageInfo['lastmessage'],
                            style: const TextStyle(
                                color: Colors.green, fontSize: 12),
                          ),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => PersonChat(
                                        name: messageInfo['receiver'],
                                        id: messageInfo['id'],
                                        token: messageInfo['token'],
                                      ))),
                        ),
                      ],
                    ),
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
    );
  }
}
