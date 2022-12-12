import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:usb_serial_for_android/transaction.dart';
import 'package:usb_serial_for_android/usb_device.dart';
import 'package:usb_serial_for_android/usb_port.dart';
import 'package:usb_serial_for_android/usb_serial_for_android.dart';

/// ## Documentation
/// #### Note
/// - This class only for A12E type of Electronic Scales
/// - This class using 1200 of baudrate. Ensure your Electronic Scales in default setting or sync your Electronic Scales with 'baudRate' parameter in this class.
/// - This class using Singleton Pattern. So, you can call this class anytime and will be return same instance.
/// - There are two parameter in the init function :
///   1. First parameter is serialDataListener, You can use this parameter for listen the data from emulator.
///   2. Second parameter is isStopUpdate. You can use this parameter to start or stop listen data from emulator.
///
/// #### Tutorial
/// 1. Add dependencies in your pubspec.yaml file => usb_serial_for_android: ^0.0.9. It will be like this :
/// ```
/// dependencies:
///   cupertino_icons: ^1.0.2
///   flutter:
///     sdk: flutter
///   usb_serial_for_android: ^0.0.9
/// ```
///
/// 2. Add this code below to your view class :
/// ```
/// final ValueNotifier<bool> _isStopUpdate = ValueNotifier(false);
///
/// @override
/// void initState() {
///   UsbSerial.usbEventStream?.listen((event) => _initScalesReal());
///
///   _initScalesReal();
///   super.initState();
/// }
///
/// @override
/// void dispose() {
///   ScalesReal().disconnect(); // Optional, but better to use.
///   super.dispose();
/// }
///
/// void _initScalesReal() {
///   ScalesReal().init(
///     serialDataListener: (value) => print(value),
///     isStopUpdate: _isStopUpdate,
///   );
/// }
/// ```
class ScalesReal {
  static const int baudRate = 1200;
  StreamSubscription<String>? subscription;
  Transaction<String>? transaction;
  List<UsbDevice?> devices = [];

  UsbPort? port;

  // Singleton Pattern
  static final ScalesReal _instance = ScalesReal._internal();
  ScalesReal._internal();
  factory ScalesReal() {
    return _instance;
  }
  // Singleton Pattern

  void init({
    required Function(String value) serialDataListener,
    required ValueNotifier<bool> isStopUpdate,
  }) async {
    devices = await UsbSerial.listDevices();

    for (var i = 0; i < devices.length; i++) {
      if (devices[i]?.pid == 9123) {
        connect(
          usbDevice: devices[i],
          dataListener: (data) {
            if (!isStopUpdate.value) {
              serialDataListener.call(data);
            }
          },
        );
        break;
      }
    }
  }

  void connect({
    required UsbDevice? usbDevice,
    required Function(String data) dataListener,
  }) async {
    disconnect();

    port = await usbDevice?.create();
    port?.open();

    await port?.setDTR(true);
    await port?.setRTS(true);
    await port?.setPortParameters(
      baudRate,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    await port?.connect();

    transaction = Transaction.stringTerminated(
      port?.inputStream as Stream<Uint8List>,
      Uint8List.fromList([13, 10]),
    );

    subscription =
        transaction?.stream.listen((String line) => dataListener.call(line));
  }

  void disconnect() {
    if (subscription != null) {
      subscription?.cancel();
      subscription = null;
    }

    if (transaction != null) {
      transaction?.dispose();
      transaction = null;
    }

    if (port != null) {
      port?.close();
      port = null;
    }
  }
}
