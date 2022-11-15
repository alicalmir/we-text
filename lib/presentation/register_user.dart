import 'package:flutter/material.dart';
import 'package:evolt_test/firebase/authentication.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  bool loading = false;
  register(BuildContext context) async {
    loading = true;

    Authentication.saveUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const SizedBox(
            height: 120,
          ),
          const Text(
            'Welcome to We Text',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            'Connect  with your friends here!',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(
            height: 250,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(300, 50),
              elevation: 10,
            ),
            onPressed: () => register(context),
            child: loading == false
                ? const Text('Chat Now 💬')
                : const CircularProgressIndicator(),
          )
        ],
      ),
    ));
  }
}
