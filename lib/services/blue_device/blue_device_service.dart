import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

import 'package:rgb_lamp_control/models/found_bluetooth_device.dart';
import 'package:rgb_lamp_control/services/services.dart';
import 'package:rgb_lamp_control/util/constants.dart';

class BlueDeviceService {
  bool isConnected = false;
  bool _isScanStarted = false;

  late FlutterBlue _bluetoothInstance;
  StreamSubscription? _scanResultsListener;

  StreamController<List<FoundDevice>> _availableToConnectDeviceList =
      StreamController<List<FoundDevice>>();

  Stream<List<FoundDevice>> get availableToConnectDeviceList =>
      _availableToConnectDeviceList.stream;

  BlueDeviceService() {
    _bluetoothInstance = getIt<FlutterBlue>();
    init();
  }

  void init() {
    _initListenersOfBluetooth();
  }

  void _initListenersOfBluetooth() {
    _scanResultsListener = _bluetoothInstance.scanResults.listen(
      (results) {
        List<FoundDevice> listOfFoundedDevices = [];
        for (ScanResult result in results) {
          try {
            FoundDevice device = FoundDevice.fromScanResult(result);
            listOfFoundedDevices.add(device);
          } catch (e) {
            print(e.toString());
          }
        }
        _availableToConnectDeviceList.sink.add(listOfFoundedDevices);
      },
    );
  }

  Future<void> startScan({int duration = 4}) async {
    if (!_isScanStarted) {
      _isScanStarted = true;
      List<ScanResult> result = await _bluetoothInstance.startScan(
        timeout: Duration(seconds: duration),
        withServices: [Guid(AppConstants.serviceUUID)],
      );
      _isScanStarted = false;
      if (result.isEmpty) {
        _availableToConnectDeviceList.sink.add([]);
      }
    }
  }

  void close() {
    _scanResultsListener?.cancel();
    _availableToConnectDeviceList.close();
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

  void processRecievedData(List<int> value) {
    if (value.isNotEmpty) {
      // used for debuggin
      // print("Recieved: ${String.fromCharCodes(value)}");
      //

      String parsedString = String.fromCharCodes(value);
      List<String> splitedString = parsedString.split(' ').toList();

      switch (parsedString.substring(0, 3)) {
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

      _deviceUpdatesStreamController.sink.add(parsedString);
    }
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
