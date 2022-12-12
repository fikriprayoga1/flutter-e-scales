 ## Documentation
#### Note
- This class only for A12E type of Electronic Scales
- This class using Singleton Pattern. So, you can call this class anytime and will be return same instance.
- There are two parameter in the init function :
    1. First parameter is serialDataListener, You can use this parameter for listen the data from emulator.
    2. Second parameter is isStopUpdate. You can use this parameter to start or stop listen data from emulator.

#### Tutorial
1. Add dependencies in your pubspec.yaml file => usb_serial_for_android: ^0.0.9. It will be like this :
```
dependencies:
    cupertino_icons: ^1.0.2
    flutter:
        sdk: flutter  
    usb_serial_for_android: ^0.0.9
```

2. Add this code below to your view class :
```
final ValueNotifier<bool> _isStopUpdate = ValueNotifier(false);
@override
void initState() {
    UsbSerial.usbEventStream?.listen((event) => _initScalesReal());

    _initScalesReal();
    super.initState();
}

@override
void dispose() {
    ScalesReal().disconnect(); // Optional, but better to use.
    super.dispose();
}

void _initScalesReal() {
    ScalesReal().init(
        serialDataListener: (value) => print(value),
        isStopUpdate: _isStopUpdate,
    );
}
```