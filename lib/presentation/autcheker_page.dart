import 'package:evolt_test/presentation/homepage.dart';
import 'package:evolt_test/presentation/register_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../firebase/authentication.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  String token = '';

  getToken() async {
    String? userToken = await Authentication.checkLoginStatus();
    if (userToken!.isEmpty || userToken == '') {
      token = '';
    } else {
      setState(() {
        token = userToken;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    if (token.isEmpty) {
      return const RegisterUser();
    } else if (token.isNotEmpty) {
      return const HomePage();
    }
    return Scaffold(
      body: Center(
        child: Text('Error'),
      ),
    );
  }
}
