import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:usb_serial_for_android/transaction.dart';
import 'package:usb_serial_for_android/usb_device.dart';
import 'package:usb_serial_for_android/usb_port.dart';
import 'package:usb_serial_for_android/usb_serial_for_android.dart';

class ScalesReal {
  StreamSubscription<String>? subscription;
  Transaction<String>? transaction;
  List<UsbDevice?> _devices = [];

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
    _devices = await UsbSerial.listDevices();

    for (var i = 0; i < _devices.length; i++) {
      if (_devices[i]?.pid == 9123) {
        connect(
          usbDevice: _devices[i],
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
      1200,
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
