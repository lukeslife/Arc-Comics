import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Global {
  static FlutterSecureStorage storage = new FlutterSecureStorage();
  static Color white = Colors.white;
  static Color blue = Colors.blue.shade900;
}
