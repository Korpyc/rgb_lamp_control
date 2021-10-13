import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';

import 'package:rgb_lamp_control/util/constants.dart';
import 'package:rgb_lamp_control/util/strings.dart';

class BlueDeviceService {
  BluetoothDevice? _device;
  StreamSubscription? _listenPortSubscription;
  StreamSubscription? _deviceStatusSubscription;
  BluetoothCharacteristic? _writePort;
  BluetoothCharacteristic? _listenPort;

  StreamController<String> _deviceUpdatesStreamController =
      StreamController<String>();

  Stream get recievedValueStream => _deviceUpdatesStreamController.stream;

  bool get isConnected => _isDeviceConnected;
  bool _isDeviceConnected = false;

  // Function to connect device and setup connection
  Future<void> connectDevice(BluetoothDevice device) async {
    _device = device;
    try {
      await _device!.connect(autoConnect: true);

      List<BluetoothService> discoverServices =
          await _device!.discoverServices();

      if (_deviceUpdatesStreamController.isClosed) {
        _deviceUpdatesStreamController = StreamController<String>();
      }

      BluetoothService service = discoverServices.firstWhere(
        (element) => element.uuid == Guid(AppConstants.serviceUUID),
      );
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          _listenPort = characteristic;
          _listenPortSubscription =
              characteristic.value.listen(processRecievedData);
        }
        if (characteristic.properties.write) {
          _writePort = characteristic;
        }
      }
      _deviceStatusSubscription = _device!.state.listen((state) {
        if (state == BluetoothDeviceState.connected) {
          _isDeviceConnected = true;
          _listenPort?.setNotifyValue(true);
          _deviceUpdatesStreamController.sink.add(AppStrings.deviceConnected);
        }
        if (state == BluetoothDeviceState.disconnected) {
          _isDeviceConnected = false;
          _deviceUpdatesStreamController.sink.add(
            AppStrings.deviceDisconnected,
          );
        }
      });
    } catch (e) {
      log(e.toString());
      await _device!.disconnect();
    }
  }

  Future<void> disconnect() async {
    try {
      _deviceUpdatesStreamController.close();

      await _deviceStatusSubscription?.cancel();
      _deviceStatusSubscription = null;
      await _listenPortSubscription?.cancel();
      _listenPortSubscription = null;
      _listenPort = null;
      _writePort = null;
      await _device?.disconnect();
    } catch (e) {
      log(e.toString());
    }
  }

  void processRecievedData(List<int> value) {
    if (value.isNotEmpty) {
      // used for debuggin
      // print("Recieved: ${String.fromCharCodes(value)}");
      //

      String parsedString = String.fromCharCodes(value);
      List<String> splitedString = parsedString.split(' ').toList();

      log('1');
      log('2');
      log('3');
      log(parsedString);
      log('3');
      log('2');
      log('1');
      /* switch (parsedString.substring(0, 3)) {
        case 'GSM':
          {
            mode = parseCurrentMode(splitedString[1]);
            break;
          }
        case 'GSL':
          {
            _isLightOn = splitedString[1] == '1' ? true : false;
            break;
          }
        case 'GSS':
          {
            parseCurrentParameters(splitedString);
            break;
          }
        default:
          break;
      }

      _deviceUpdatesStreamController.sink.add(parsedString); */
    }
  }

  void close() {
    _listenPortSubscription?.cancel();
    _deviceUpdatesStreamController.sink.close();
    _deviceUpdatesStreamController.close();
    _deviceStatusSubscription?.cancel();
    _writePort = null;
    _listenPort = null;
    _device?.disconnect();
  }

  /* BluetoothDevice? _device;
  BluetoothCharacteristic? _writePort;
  BluetoothCharacteristic? _listenPort;
  StreamSubscription? _listenPortSubscription;
  StreamSubscription? _deviceStatusSubscription;

  StreamController<String> _deviceUpdatesStreamController =
      StreamController<String>();

  Stream get recievedValueStream => _deviceUpdatesStreamController.stream;

  bool get isConnected => _isDeviceConnected;
  bool get isLedEnabled => _isLightOn;
  bool _isDeviceConnected = false;
  bool _isLightOn = false;
  BlueDeviceMode mode = BlueDeviceMode.undefined;
  bool _isBusy = false;
  String _bufferValue = '';
  dynamic lastRecievedParameters;

  // Function to connect device and setup connection
  Future<void> connectDevice(BluetoothDevice device) async {
    _device = device;
    try {
      if (await _device!.state.first == BluetoothDeviceState.disconnected) {
        await _device!.connect();
      }

      List<BluetoothService> discoverServices =
          await _device!.discoverServices();

      BluetoothService service = discoverServices.firstWhere(
        (element) => element.uuid.toString().contains(AppConstants.serviceUUID),
      );
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          _listenPort = characteristic;
          _listenPortSubscription =
              _listenPort!.value.listen(processRecievedData);
        }
        if (characteristic.properties.write) {
          _writePort = characteristic;
        }
      }
      _deviceStatusSubscription = _device!.state.listen((state) {
        if (state == BluetoothDeviceState.connected) {
          _isDeviceConnected = true;
          _listenPort?.setNotifyValue(true);
          _deviceUpdatesStreamController.sink.add('Device conected');
          getStatus();
        }
        if (state == BluetoothDeviceState.disconnected) {
          _isDeviceConnected = false;
          _deviceUpdatesStreamController.sink.add('Device disconected');
        }
      });
    } catch (e) {
      await _device!.disconnect();
      print(e);
    }
  }

  Future<void> getStatus() async {
    Future.delayed(Duration(milliseconds: 100), () {
      return sendData('\$1;');
    });
  }

  

  void parseCurrentParameters(List<String> splitedString) {
    List<int> listOfParameters = [];
    if (splitedString.length == 7) {
      for (int i = 1; i < 6; i++) {
        listOfParameters.add(
          int.parse(splitedString[i]),
        );
      }

      switch (mode) {
        case BlueDeviceMode.rgb:
          {
            lastRecievedParameters = RGBModeParams(
              brightness: listOfParameters[0],
              whiteColor: listOfParameters[4],
              redColor: listOfParameters[1],
              greenColor: listOfParameters[2],
              blueColor: listOfParameters[3],
            );
            break;
          }
        case BlueDeviceMode.color:
          {
            lastRecievedParameters = ColorModeParams(
              brightness: listOfParameters[0],
              whiteColor: listOfParameters[2],
              numberOfColor: listOfParameters[1],
            );
            break;
          }
        case BlueDeviceMode.fire:
          {
            lastRecievedParameters = FireModeParams(
              brightness: listOfParameters[0],
              speed: listOfParameters[1],
              min: listOfParameters[2],
            );
            break;
          }

        default:
          {
            lastRecievedParameters = null;
            break;
          }
      }
    }
  }

  BlueDeviceMode parseCurrentMode(String mode) {
    /*  print('\n');
    print('\n');
    print('\n');
    print('Mode is - $mode');
    print('\n');
    print('\n');
    print('\n'); */
    switch (mode) {
      case '1':
        return BlueDeviceMode.rgb;
      case '2':
        return BlueDeviceMode.rgb;
      case '3':
        return BlueDeviceMode.color;
      case '7':
        return BlueDeviceMode.fire;

      default:
        return BlueDeviceMode.undefined;
    }
  }

  Stream dataStreamFromDevice() async* {}

  // Send string data to device
  Future<void> sendData(String data) async {
    try {
      if (!_isBusy) {
        _isBusy = true;
        // used for debuggin
        // print("Sended: $data");
        await _writePort?.write(data.codeUnits);
        if (_bufferValue == data) {
          _bufferValue = '';
        }
        _isBusy = false;
      } else {
        _bufferValue = data;
        Future.delayed(Duration(milliseconds: 10), () {
          if (_bufferValue != '') {
            sendData(_bufferValue);
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> setMode(BlueDeviceMode mode) async {
    String setModeCommand = '';

    switch (mode) {
      case BlueDeviceMode.rgb:
        {
          setModeCommand = AppConstants.rgbModeCommand;
          break;
        }
      case BlueDeviceMode.color:
        {
          setModeCommand = AppConstants.colorModeCommand;
          break;
        }
      case BlueDeviceMode.fire:
        {
          setModeCommand = AppConstants.fireModeCommand;
          break;
        }

      default:
    }
    if (setModeCommand != '') {
      await sendData(setModeCommand);
    }
  }

  // Disconnect device
  Future<void> disconnectDevice() async {
    _deviceUpdatesStreamController.close();
    _listenPortSubscription?.cancel();
    await _device?.disconnect();
    FlutterBlue.instance.connectedDevices.then(
      (value) => value.forEach(
        (element) {
          element.disconnect();
        },
      ),
    );
  } */
}
