import 'dart:math';

import 'package:flutter/material.dart';

/// # Documentation
/// - This class using Singleton Pattern. So, you can call this class anytime and will return same instance.
/// - There are two parameter in the init function :
///   1. First parameter is serialDataListener, You can use this parameter for listen the data from emulator.
///   2. Second parameter is isStopUpdate. You can use this parameter to start or stop listen data from emulator.
/// - See example below :
/// ```
///
/// final ValueNotifier<bool> _isStopUpdate = ValueNotifier(false);
///
/// void _initSCE() async {
///   ScalesControllerEmulator().init(
///     serialDataListener: (value) {
///       _formController.text = value;
///     },
///     isStopUpdate: _isStopUpdate,
///   );
///
///   await Future.delayed(const Duration(seconds: 10));
///   _isStopUpdate.value = true;
///   await Future.delayed(const Duration(seconds: 10));
///   _isStopUpdate.value = false;
/// }
/// ```
class ScalesControllerEmulator {
  Function(String data)? _serialDataListener;
  late ValueNotifier<bool> _isStopUpdate;

  // Singleton Pattern
  static final ScalesControllerEmulator _instance =
      ScalesControllerEmulator._internal();
  ScalesControllerEmulator._internal();
  factory ScalesControllerEmulator() {
    return _instance;
  }
  // Singleton Pattern

  void init({
    required Function(String data) serialDataListener,
    required ValueNotifier<bool> isStopUpdate,
  }) {
    if (_serialDataListener == null) {
      _serialDataListener = serialDataListener;
      _isStopUpdate = isStopUpdate;
      runEmulator();
    }
  }

  void runEmulator() async {
    while (true) {
      await _emulatorProcess();
    }
  }

  Future<void> _emulatorProcess() async {
    const Duration duration = Duration(milliseconds: 100);
    for (var i = 0; i < 20; i++) {
      await Future.delayed(
        duration,
        () {
          if (!_isStopUpdate.value) {
            _serialDataListener?.call('0000.00 (kg)');
          }
        },
      );
    }

    for (var i = 0; i < 30; i++) {
      await Future.delayed(duration, () {
        if (!_isStopUpdate.value) {
          _serialDataListener?.call(randomWeight());
        }
      });
    }

    for (var i = 0; i < 30; i++) {
      await Future.delayed(
        duration,
        () {
          if (!_isStopUpdate.value) {
            _serialDataListener?.call('00010.50 (kg)');
          }
        },
      );
    }

    for (var i = 0; i < 20; i++) {
      await Future.delayed(
        duration,
        () {
          if (!_isStopUpdate.value) {
            _serialDataListener?.call('00009.00 (kg)');
          }
        },
      );
    }

    for (var i = 0; i < 50; i++) {
      await Future.delayed(
        duration,
        () {
          if (!_isStopUpdate.value) {
            _serialDataListener?.call('00010.00 (kg)');
          }
        },
      );
    }
  }

  String randomWeight() {
    final randomNumber = 9 + Random().nextInt(12 - 9);
    final randomNumberDecimal = Random().nextInt(10);
    late String stringRandomNumber;
    late String stringRandomNumberDecimal;

    if (randomNumber >= 10) {
      stringRandomNumber = '000$randomNumber';
    } else {
      stringRandomNumber = '0000$randomNumber';
    }

    if (randomNumberDecimal == 10) {
      stringRandomNumberDecimal = randomNumberDecimal.toString();
    } else {
      stringRandomNumberDecimal = '0$randomNumberDecimal';
    }

    return '$stringRandomNumber.$stringRandomNumberDecimal (kg)';
  }
}
