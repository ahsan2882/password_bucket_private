import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:password_bucket_private/states/current_user.dart';
import 'package:provider/provider.dart';
import 'value_notifiers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'PK');

  final ValueNotifier<bool> _showPassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _showConfirmPassword = ValueNotifier<bool>(true);
  final ValueNotifier<String> _fullNameNotifier = ValueNotifier<String>('');
  final ValueNotifier _phoneNumberNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _emailNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _passwordNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _confirmPasswordNotifier =
      ValueNotifier<String>('');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _register(context) async {
    _emailNotifier.value = emailController.text;
    _passwordNotifier.value = passwordController.text;
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      disableRegisterButton.value = true;
      var result = await currentUser.signUpUser(
          name: _fullNameNotifier.value,
          phoneNumber: _phoneNumberNotifier.value,
          email: _emailNotifier.value,
          password: _passwordNotifier.value);
      if (!result) {
        throw Error();
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      disableRegisterButton.value = false;
    }
  }

  _togglePasswordVisibility(ValueNotifier<bool> notifier) {
    notifier.value = !notifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: constraints.minWidth,
                      minHeight: constraints.minHeight,
                      maxHeight: constraints.maxHeight),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Spacer(flex: 15),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: TextFormField(
                              onChanged: (text){
                                _fullNameNotifier.value = text;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Full Name',
                              ),
                              controller: fullNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name!';
                                }
                                return null;
                              },
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: Center(
                              child: InternationalPhoneNumberInput(
                                initialValue: number,
                                onInputChanged: (PhoneNumber value) {
                                  _phoneNumberNotifier.value = value.toString();
                                },
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Email',
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
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: ValueListenableBuilder(
                              valueListenable: _showPassword,
                              builder:
                                  (BuildContext context, bool showPassword, _) {
                                return ValueListenableBuilder(
                                    valueListenable: _passwordNotifier,
                                    builder: (BuildContext context,
                                        String passwordText, _) {
                                      return TextFormField(
                                        onChanged: (text) {
                                          _passwordNotifier.value = text;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Password',
                                            suffixIcon: passwordText.isNotEmpty
                                                ? IconButton(
                                                    onPressed: () =>
                                                        _togglePasswordVisibility(
                                                            _showPassword),
                                                    icon: Icon(showPassword
                                                        ? Icons.visibility
                                                        : Icons.visibility_off))
                                                : null),
                                        controller: passwordController,
                                        obscureText: showPassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password!';
                                          }
                                          if (!RegExp(
                                                  "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}")
                                              .hasMatch(value)) {
                                            return 'Password must contain at least 8 characters,\nmust contain at least 1 uppercase letter,\n1 lowercase letter, 1 number\nand a special character';
                                          }
                                          return null;
                                        },
                                      );
                                    });
                              },
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: ValueListenableBuilder(
                              valueListenable: _showConfirmPassword,
                              builder: (BuildContext context,
                                  bool showConfirmPassword, _) {
                                return ValueListenableBuilder(
                                    valueListenable: _confirmPasswordNotifier,
                                    builder: (BuildContext context,
                                        String confirmPasswordText, _) {
                                      return TextFormField(
                                        onChanged: (text) {
                                          _confirmPasswordNotifier.value = text;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Confirm Password',
                                            suffixIcon: confirmPasswordText
                                                    .isNotEmpty
                                                ? IconButton(
                                                    onPressed: () =>
                                                        _togglePasswordVisibility(
                                                            _showConfirmPassword),
                                                    icon: Icon(
                                                        showConfirmPassword
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off))
                                                : null),
                                        controller: confirmPasswordController,
                                        obscureText: showConfirmPassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please confirm your password!';
                                          }
                                          if (value !=
                                              passwordController.text) {
                                            return 'Passwords do not match!';
                                          }
                                          if (!RegExp(
                                                  "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}")
                                              .hasMatch(value)) {
                                            return 'Password must contain at least 8 characters,\nmust contain at least 1 uppercase letter,\n1 lowercase letter, 1 number\nand a special character';
                                          }
                                          return null;
                                        },
                                      );
                                    });
                              },
                            ),
                          ),
                          const Spacer(),
                          ValueListenableBuilder(
                            builder:
                                (BuildContext context, bool disableButton, _) {
                              return ElevatedButton(
                                  onPressed: disableButton
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _register(context);
                                          }
                                        },
                                  child: const Text('Register'));
                            },
                            valueListenable: disableRegisterButton,
                          ),
                          const Spacer(flex: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: showMessagePopup,
            builder: (BuildContext context, bool showPopup, _) {
              return ValueListenableBuilder(
                  valueListenable: showMessagePopupText,
                  builder: (BuildContext context, String textMessage, _) {
                    if (showPopup) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 75,
                        color: const Color.fromARGB(200, 222, 46, 33),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.warning_amber),
                            Text(textMessage)
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  });
            },
          )
        ],
      ),
    );
  }
}
