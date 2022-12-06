import 'package:flutter/material.dart';

class SizeUnit {
  late double _widthUnit;
  late double _heightUnit;

  // Singleton Pattern
  static final SizeUnit _instance = SizeUnit._internal();
  SizeUnit._internal();
  factory SizeUnit() {
    return _instance;
  }
  // Singleton Pattern

  void init({required BuildContext context}) {
    final Size _screenSize = MediaQuery.of(context).size;
    _widthUnit = _screenSize.width / 1080;
    _heightUnit = _screenSize.height / 2040;
  }

  double width(int size) {
    return size * _widthUnit;
  }

  double height(int size) {
    return size * _heightUnit;
  }
}
