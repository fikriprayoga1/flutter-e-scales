import 'package:flutter_e_scales/size_unit.dart';
import 'package:flutter/material.dart';
import 'package:serial_communication/serial_communication.dart';

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
  final SerialCommunication _serialCommunication = SerialCommunication();
  final List<DropdownMenuItem<String>> _serialPortList = [];
  final ValueNotifier<String> _selectedPort = ValueNotifier('none');

  @override
  void initState() {
    _serialCommunication.startSerial().listen((event) {
      final logData = event.logChannel ?? "";
      final receivedData = event.readChannel ?? "";
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final List<String>? _portList =
          await _serialCommunication.getAvailablePorts();
      print('debug_mode : $_serialPortList');

      if (_portList != null) {
        for (var element in _portList) {
          _serialPortList.add(
            DropdownMenuItem(value: element, child: Text(element)),
          );
        }
        setState(() {});
      }
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
