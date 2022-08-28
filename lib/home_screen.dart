import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_bucket_private/login_screen.dart';
import 'package:password_bucket_private/verify_email_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _routeToSignIn() async{
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to your vault'),
        actions: <Widget>[
          IconButton(onPressed: () async {
            await _auth.signOut();
            await _routeToSignIn();
          }, icon: const Icon(Icons.power_settings_new))
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.minWidth,
                  minHeight: constraints.minHeight,
                  maxHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const VerifyEmailPage()));
                        }, child: const Text('Verify email')),
                    ElevatedButton(
                        onPressed: () {}, child: const Text('Verify Phone Number'))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
