import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:password_bucket_private/login_screen.dart';
import 'package:password_bucket_private/states/current_user.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:password_bucket_private/value_notifiers.dart';
import 'package:password_bucket_private/passwords_functions.dart' as functions;
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CurrentUser(),
      child: MaterialApp(
        title: 'Secure Vault',
        theme: ThemeData(
            primarySwatch: functions
                .createMaterialColor(const Color.fromRGBO(9, 11, 115, 1.0))),
        home: const MyHomePage(title: 'Secure Vault'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    _checkConnection();
    super.initState();
  }

  void _route() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  _routeToHomePage() async {
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  _checkConnection() async {
    bool status = await InternetConnectionChecker().hasConnection;
    if (status) {
      await Future.delayed(const Duration(seconds: 3));
      if (FirebaseAuth.instance.currentUser != null) {
        isUserLoggedInNotifier.value = true;
        print(FirebaseAuth.instance.currentUser);
        _routeToHomePage();
      } else{
        isUserLoggedInNotifier.value = false;
        _route();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/vault.png'), context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
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
                const Spacer(flex: 15),
                Text(
                  'PassVault',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30 * MediaQuery.of(context).size.width / 423),
                ),
                const Spacer(),
                const Image(
                  image: AssetImage('assets/images/vault.png'),
                ),
                const Spacer(),
                Text(
                  'Your personal secure vault',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20 * MediaQuery.of(context).size.width / 423
                  ),
                ),
                const Spacer(flex: 15),
              ],
            ),
          ),
        ));
      }),
    );
  }
}
