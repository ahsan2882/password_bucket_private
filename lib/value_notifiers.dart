import 'package:flutter/material.dart';

ValueNotifier<bool> loggedIn = ValueNotifier<bool>(false);

ValueNotifier<bool> disableRegisterButton = ValueNotifier<bool>(false);
ValueNotifier<bool> showMessagePopup = ValueNotifier<bool>(false);
ValueNotifier<String> showMessagePopupText = ValueNotifier<String>('');