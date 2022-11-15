import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:evolt_test/const.dart';

import 'package:evolt_test/firebase/notification.dart';
import 'package:evolt_test/firebase/stream_firebase.dart';
import 'package:evolt_test/presentation/chat_page.dart';
import 'package:evolt_test/presentation/one_to_one.dart';
import 'package:evolt_test/presentation/chat_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase/authentication.dart';
import '../firebase/chat.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int selectedndex = 0;
String username = '';
//[List of screens]
List<Widget> screens = [
  const ChatPage(),
  const UsersList(),
];

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  @override
  initState() {
    super.initState();
    getname();
    PushNoti.push();
    WidgetsBinding.instance.addObserver(this);
    Chat.makeUserOnline(status: true);
  }

  getname() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? name = pref.getString('name');
    String? currentuser = pref.getString('id');
    setState(() {
      username = name!;
      userID = currentuser!;
    });
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Chat.makeUserOnline(status: true);
    } else {
      Chat.makeUserOnline(status: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('We Text'),
        actions: [Center(child: Text(username))],
      ),
      drawer: Drawer(
        child: Center(
            child: StreamBuilder(
          stream: StreamFirebaseFireStore.userList,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot<Map<String, dynamic>> userInfo =
                        snapshot.data!.docs[index];

                    return Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 14),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              userInfo['name'],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                            trailing: Icon(
                              Icons.circle_rounded,
                              color: userInfo['status'] == true
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => PersonChat(
                                        name: userInfo['name'],
                                        id: userInfo['id'],
                                        token: userInfo['token'],
                                      )));
                            },
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
      ),
      body: screens.elementAt(selectedndex),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              selectedndex = index;
            });
          },
          currentIndex: selectedndex,
          items: [
            BottomNavigationBarItem(
                icon: Container(
                    child: SvgPicture.asset('assets/message-circle.svg',
                        height: 30, width: 30)),
                label: 'Group'),
            BottomNavigationBarItem(
                icon: Container(
                    child: SvgPicture.asset('assets/users.svg',
                        height: 30, width: 30)),
                label: 'Chat'),
          ]),
    );
  }
}
