import 'package:flutter_e_scales/core/scales_real.dart';
import 'package:flutter_e_scales/core/scales_emulator.dart';
import 'package:flutter_e_scales/core/helper.dart';
import 'package:flutter_e_scales/size_unit.dart';
import 'package:flutter/material.dart';
import 'package:usb_serial_for_android/usb_serial_for_android.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _formController = TextEditingController();
  final ValueNotifier<bool> _isRealMode = ValueNotifier(false);
  final ValueNotifier<bool> _isStopUpdate = ValueNotifier(false);
  bool hasInitScalesReal = false;

  @override
  void initState() {
    _initScalesEmulator();
    UsbSerial.usbEventStream?.listen((event) => _initScalesReal());

    _initScalesReal();
    super.initState();
  }

  @override
  void dispose() {
    ScalesReal().disconnect();
    super.dispose();
  }

  void _initScalesReal() {
    ScalesReal().init(
      serialDataListener: (value) {
        if (_isRealMode.value) {
          _formController.text = value.ekanKg();
        }
      },
      isStopUpdate: _isStopUpdate,
    );
  }

  void _initScalesEmulator() {
    ScalesEmulator().init(
      serialDataListener: (value) {
        if (!_isRealMode.value) {
          _formController.text = value.ekanKg();
        }
      },
      isStopUpdate: _isStopUpdate,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeUnit().init(context: context);
    return Scaffold(
      appBar: AppBar(title: const Text('E-Scales Template')),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeUnit().height(50),
        horizontal: SizeUnit().width(50),
      ),
      child: ValueListenableBuilder(
        valueListenable: _isRealMode,
        builder: (BuildContext context, value, Widget? child) {
          return Column(
            children: [
              SizedBox(height: SizeUnit().height(100)),
              _switchButton(),
              SizedBox(height: SizeUnit().height(100)),
              _formSection(),
            ],
          );
        },
      ),
    );
  }

  Widget _formSection() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _form(),
          SizedBox(width: SizeUnit().width(75)),
          _setButton(),
        ],
      ),
    );
  }

  Widget _form() {
    return SizedBox(
      width: SizeUnit().width(450),
      child: ValueListenableBuilder(
        valueListenable: _isStopUpdate,
        builder: (BuildContext context, value, Widget? child) {
          return TextField(
            controller: _formController,
            decoration: InputDecoration(
              focusedBorder: _formBorder(),
              enabledBorder: _formBorder(),
              fillColor: Colors.lightGreen,
              filled: _isStopUpdate.value,
            ),
            style: TextStyle(
              color: _isStopUpdate.value ? Colors.white : null,
            ),
            readOnly: !_isStopUpdate.value,
          );
        },
      ),
    );
  }

  OutlineInputBorder _formBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: _isStopUpdate.value ? Colors.green : Colors.black,
      ),
    );
  }

  Widget _setButton() {
    return InkWell(
      onTap: () => _isStopUpdate.value = !_isStopUpdate.value,
      child: ValueListenableBuilder(
        valueListenable: _isStopUpdate,
        builder: (BuildContext context, value, Widget? child) {
          return Container(
            width: SizeUnit().width(300),
            height: double.infinity,
            decoration: BoxDecoration(
              color: _isStopUpdate.value ? Colors.lightGreen : Colors.amber,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                _isStopUpdate.value ? 'Count' : 'Set',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _switchButton() {
    return ValueListenableBuilder(
      valueListenable: _isRealMode,
      builder: (BuildContext context, value, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Switch(
              value: _isRealMode.value,
              onChanged: (value) => _isRealMode.value = value,
            ),
            SizedBox(
              width: SizeUnit().width(300),
              child: Text(_isRealMode.value ? 'Real Mode' : 'Emulator Mode'),
            ),
          ],
        );
      },
    );
  }
}
