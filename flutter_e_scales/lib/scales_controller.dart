import 'dart:typed_data';

import 'package:flutter_e_scales/size_unit.dart';
import 'package:flutter/material.dart';

// import 'package:usb_serial/usb_serial.dart';
// import 'package:quick_usb/quick_usb.dart';
// import 'package:flutter_libserialport/flutter_libserialport.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:serial_communication/serial_communication.dart';

class ScalesController extends StatefulWidget {
  final Function(String data)? serialDataListener;
  final ValueNotifier<bool> isStopUpdate;

  const ScalesController({
    super.key,
    required this.serialDataListener,
    required this.isStopUpdate,
  });

  @override
  State<ScalesController> createState() => _ScalesControllerState();
}

class _ScalesControllerState extends State<ScalesController> {
  final List<DropdownMenuItem<String>> _serialPortList = [];
  final ValueNotifier<String> _selectedPort = ValueNotifier('none');

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // List<UsbDevice> devices = await UsbSerial.listDevices();
      // print('debug_mode : devices[1].deviceId => ${devices[1].deviceId}');
      // print('debug_mode : devices[1].deviceName => ${devices[1].deviceName}');

      // UsbPort? port;
      // if (devices.length == 0) {
      //   return;
      // }
      // port = await devices[1].create();

      // if(port != null) {
      //   bool openResult = await port.open();
      // if (!openResult) {
      //   print("Failed to open");
      //   return;
      // }

      // await port.setDTR(true);
      // await port.setRTS(true);

      // port.setPortParameters(
      //     115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

      // // print first result and close port.
      // port.inputStream?.listen((Uint8List event) {
      //   print(event);
      //   port?.close();
      // });
      // }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeUnit().height(100)),
        _controllerSpace(),
        SizedBox(height: SizeUnit().height(200)),
      ],
    );
  }

  Widget _controllerSpace() {
    return Card(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _reinitButton(),
            SizedBox(height: SizeUnit().height(150)),
            _dropdownPortList(),
          ],
        ),
      ),
    );
  }

  Widget _dropdownPortList() {
    return ValueListenableBuilder(
      valueListenable: _selectedPort,
      builder: (BuildContext context, value, Widget? child) {
        return DropdownButton(
          isExpanded: true,
          value: _selectedPort.value,
          // items: _serialPortList,
          items: [
            DropdownMenuItem<String>(
              value: 'none',
              onTap: (() => _selectedPort.value = 'none'),
              child: const Text('none'),
            ),
            DropdownMenuItem<String>(
              value: 'COM3',
              onTap: (() => _selectedPort.value = 'COM3'),
              child: const Text('COM3'),
            ),
            DropdownMenuItem<String>(
              value: 'COM4',
              onTap: (() => _selectedPort.value = 'COM4'),
              child: const Text('COM4'),
            ),
          ],
          onChanged: (value) {},
        );
      },
    );
  }

  Widget _reinitButton() {
    return InkWell(
      onTap: () {},
      child: _buttonLayout(data: 'RE-INIT'),
    );
  }

  Widget _buttonLayout({
    required String data,
    Color backgroundColor = Colors.amber,
  }) {
    return Container(
      width: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Center(child: Text(data)),
    );
  }
}
