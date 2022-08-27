import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:password_bucket_private/register_screen.dart';

import 'value_notifiers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  void initState() {
    // TODO: implement initState
    _checkUserAuth();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _checkUserAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
     loggedIn.value = (user == null);
    });
  }
  _routeToRegister() async{
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void _loginWithGoogle() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Spacer(flex: 3),
            ElevatedButton(
                onPressed: _loginWithGoogle,
                child: const Text('Login with Google')),
            const Spacer(),
            ElevatedButton(
                onPressed: _routeToRegister,
                child: const Text('Register using Email')),
            const Spacer(flex: 3)
          ],
        ),
      ),
    ));
  }
}
