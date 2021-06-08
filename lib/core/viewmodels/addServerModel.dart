import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

class AddServerModel extends ChangeNotifier {
  get isVisible => _isVisible;
  bool _isVisible = false;
  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  get isValid => _isValid;
  bool _isValid = false;
  void isValidEmail(String input) {
    if (emailRegExp.hasMatch(input)) {
      _isValid = true;
    } else {
      _isValid = false;
    }
    notifyListeners();
  }
}
