import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:password_bucket_private/states/current_user.dart';
import 'package:provider/provider.dart';
import 'value_notifiers.dart';
import 'package:password_bucket_private/passwords_functions.dart' as functions;

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

  final ValueNotifier<bool> showPasswordNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> showConfirmPasswordNotifier =
      ValueNotifier<bool>(true);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    disableRegisterButtonNotifier.value = false;
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
    emailNotifier.value = emailController.text;
    passwordNotifier.value = passwordController.text;
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      disableRegisterButtonNotifier.value = true;
      var result = await currentUser.signUpUser(
          name: fullNameNotifier.value,
          phoneNumber: phoneNumberNotifier.value,
          email: emailNotifier.value,
          password: passwordNotifier.value);
      if (!result) {
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
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      disableRegisterButtonNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
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
                          onChanged: (text) {
                            fullNameNotifier.value = text;
                          },
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
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
                              phoneNumberNotifier.value = value.toString();
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
                          keyboardType: TextInputType.emailAddress,
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
                                        hintText: 'Password',
                                        suffixIcon: passwordText.isNotEmpty
                                            ? IconButton(
                                                onPressed: () => functions
                                                    .togglePasswordVisibility(
                                                        showPasswordNotifier),
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
                          valueListenable: showConfirmPasswordNotifier,
                          builder: (BuildContext context,
                              bool showConfirmPassword, _) {
                            return ValueListenableBuilder(
                                valueListenable: confirmPasswordNotifier,
                                builder: (BuildContext context,
                                    String confirmPasswordText, _) {
                                  return TextFormField(
                                    onChanged: (text) {
                                      confirmPasswordNotifier.value = text;
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Confirm Password',
                                        suffixIcon: confirmPasswordText
                                                .isNotEmpty
                                            ? IconButton(
                                                onPressed: () => functions
                                                    .togglePasswordVisibility(
                                                        showConfirmPasswordNotifier),
                                                icon: Icon(showConfirmPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off))
                                            : null),
                                    controller: confirmPasswordController,
                                    obscureText: showConfirmPassword,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password!';
                                      }
                                      if (value != passwordController.text) {
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
                        builder: (BuildContext context, bool disableButton, _) {
                          return ElevatedButton(
                              onPressed: disableButton
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        _register(context);
                                      }
                                    },
                              child: const Text('Register'));
                        },
                        valueListenable: disableRegisterButtonNotifier,
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
    );
  }
}
