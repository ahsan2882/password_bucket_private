import 'package:flutter/material.dart';
import 'package:password_bucket_private/home_screen.dart';
import 'package:password_bucket_private/register_screen.dart';
import 'package:password_bucket_private/states/current_user.dart';
import 'package:provider/provider.dart';
import 'value_notifiers.dart';
import 'package:password_bucket_private/passwords_functions.dart' as functions;
// import 'package:local_auth/local_auth.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final ValueNotifier<bool> showPasswordNotifier = ValueNotifier<bool>(true);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _routeToRegister() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void _loginWithEmailAndPassword(context) async {
    emailNotifier.value = emailController.text;
    passwordNotifier.value = passwordController.text;
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    bool result = await currentUser.loginWithEmail(
        email: emailNotifier.value, password: passwordNotifier.value);
    if (result) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: ValueListenableBuilder(
            valueListenable: showMessagePopupTextNotifier,
            builder: (BuildContext context, String message, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.warning_amber),
                  Text(message)
                ],
              );
            }),
        backgroundColor: const Color.fromARGB(200, 222, 46, 33),
        duration: const Duration(seconds: 5),
      ));
    }
  }

  void _loginWithGoogle(context) async {
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);
    await currentUser.loginWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
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
                  const Spacer(flex: 15),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Email',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                            ),
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email!';
                              }
                              if (!RegExp(
                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return 'Please enter a valid email!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: ValueListenableBuilder(
                              valueListenable: showPasswordNotifier,
                              builder:
                                  (BuildContext context, bool showPassword, _) {
                                return ValueListenableBuilder(
                                    valueListenable: passwordNotifier,
                                    builder: (BuildContext context,
                                        String passwordText, _) {
                                      return TextFormField(
                                        onChanged: (text) {
                                          passwordNotifier.value = text;
                                        },
                                        decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: 'Password',
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                  color: Colors.red, width: 2),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                  color: Colors.red, width: 2),
                                            ),
                                            suffixIcon: passwordText.isNotEmpty
                                                ? IconButton(
                                                    onPressed: () => functions
                                                        .togglePasswordVisibility(
                                                            showPasswordNotifier),
                                                    icon: Icon(
                                                      color: Colors.grey,
                                                      showPassword
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                    ))
                                                : null),
                                        controller: passwordController,
                                        obscureText: showPassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password!';
                                          }
                                          return null;
                                        },
                                      );
                                    });
                              },
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 200,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              primary: const Color.fromRGBO(63, 125, 217, 1.0),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _loginWithEmailAndPassword(context);
                              }
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(flex: 4),
                  SizedBox(
                    width: 300,
                    height: 2,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(flex: 4),
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        primary: const Color.fromRGBO(63, 125, 217, 1.0),
                      ),
                      onPressed: () {
                        _loginWithGoogle(context);
                      },
                      child: const Text(
                        'Login with Google',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        primary: const Color.fromRGBO(63, 125, 217, 1.0),
                      ),
                      onPressed: _routeToRegister,
                      child: const Text(
                        'Register using Email',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const Spacer(flex: 10)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
