import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:password_bucket_private/states/current_user.dart';
import 'package:phone_number/phone_number.dart' as phone;
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
  final phoneNumberController = TextEditingController();

  // PhoneNumber number = PhoneNumber(isoCode: 'PK');

  final ValueNotifier<bool> isPhoneNumberValidNotifier =
      ValueNotifier<bool>(true);

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
    phoneNumberController.dispose();
    super.dispose();
  }

  validatePhoneNumber({required String phoneNumber}) async {
    // phone.PhoneNumber parsedPhoneNumber =
    //     await phone.PhoneNumberUtil().parse(phoneNumber);
    try {
      isPhoneNumberValidNotifier.value =
          await phone.PhoneNumberUtil().validate(phoneNumber);
    } on Exception catch (e) {
      isPhoneNumberValidNotifier.value = false;
    }
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
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Full Name',
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
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
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
                          child: ValueListenableBuilder(
                              valueListenable: isPhoneNumberValidNotifier,
                              builder: (context, bool validPhoneNumber, _) {
                                return TextFormField(
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'Phone Number: +xx xxx xxxxxxx',
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
                                  controller: phoneNumberController,
                                  onChanged: (text) {
                                    phoneNumberNotifier.value = text;
                                    validatePhoneNumber(phoneNumber: text);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter a phone number!';
                                    }
                                    if (!RegExp("^[+]").hasMatch(value)) {
                                      return "Enter phone number with area code";
                                    }
                                    if (!validPhoneNumber) {
                                      return "Enter a valid phone number";
                                    }
                                    return null;
                                  },
                                );
                              })),
                      const Spacer(),
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
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
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
                                              icon: Icon(
                                                  color: Colors.grey,
                                                  showPassword
                                                      ? Icons.visibility
                                                      : Icons.visibility_off))
                                          : null,
                                      fillColor: Colors.white,
                                      filled: true,
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
                                        fillColor: Colors.white,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 2),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 2),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 2),
                                        ),
                                        hintText: 'Confirm Password',
                                        suffixIcon: confirmPasswordText
                                                .isNotEmpty
                                            ? IconButton(
                                                onPressed: () => functions
                                                    .togglePasswordVisibility(
                                                        showConfirmPasswordNotifier),
                                                icon: Icon(
                                                    color: Colors.grey,
                                                    showConfirmPassword
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
                          return SizedBox(
                            width: 200,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                primary:
                                    const Color.fromRGBO(63, 125, 217, 1.0),
                              ),
                              onPressed: disableButton
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        _register(context);
                                      }
                                    },
                              child: const Text(
                                'Register',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
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
