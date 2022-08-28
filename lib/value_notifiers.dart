import 'package:flutter/material.dart';


final ValueNotifier<bool> disableRegisterButtonNotifier = ValueNotifier<bool>(false);
final ValueNotifier<String> showMessagePopupTextNotifier = ValueNotifier<String>('');

final ValueNotifier<String> fullNameNotifier = ValueNotifier<String>('');
final ValueNotifier<String> phoneNumberNotifier = ValueNotifier<String>('');
final ValueNotifier<String> emailNotifier = ValueNotifier<String>('');
final ValueNotifier<String> passwordNotifier = ValueNotifier<String>('');
final ValueNotifier<String> confirmPasswordNotifier =
ValueNotifier<String>('');
final ValueNotifier<bool> isUserLoggedInNotifier = ValueNotifier<bool>(false);