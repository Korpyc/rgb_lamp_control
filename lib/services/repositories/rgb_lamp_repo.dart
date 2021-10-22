import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';

import 'package:rgb_lamp_control/models/color_mode_params.dart';
import 'package:rgb_lamp_control/models/fire_mode_params.dart';
import 'package:rgb_lamp_control/models/rgb_mode_params.dart';
import 'package:rgb_lamp_control/services/bluetooth/blue_device_service.dart';
import 'package:rgb_lamp_control/util/strings.dart';

enum RgbLampMode {
  rgb,
  color,
  fire,
  undefined,
}

enum RgbLampLightStatus {
  on,
  off,
}

abstract class RgbLampRepo {
  Stream get lampUpdates;
  bool get isDeviceConnected;
  RgbLampMode get currentMode;
  bool get isLampOn;
  Future<void> connectDevice(BluetoothDevice device);
  Future<void> disconnectDevice();
  Future<void> sendData(String data);
  void close();
}

class RgbLampRepoImpl extends RgbLampRepo {
  StreamSubscription? _lampUpdatesSubscription;

  StreamController<String> _lampUpdatesStreamController =
      StreamController<String>.broadcast();

  Stream get lampUpdates => _lampUpdatesStreamController.stream;

  // current mode of lamp light
  RgbLampMode _mode = RgbLampMode.undefined;
  RgbLampLightStatus _lampLightStatus = RgbLampLightStatus.off;
  dynamic _lastRecievedParameters;

  bool get isDeviceConnected => _deviceService.isConnected;
  RgbLampMode get currentMode => _mode;
  bool get isLampOn => _lampLightStatus == RgbLampLightStatus.on ? true : false;
  dynamic get currentParameters => _lastRecievedParameters;

  final BlueDeviceService _deviceService;
  RgbLampRepoImpl(this._deviceService);

  void _listenUpdatesFromLamp() {
    if (_lampUpdatesSubscription == null) {
      _lampUpdatesSubscription = _deviceService.recievedValueStream.listen(
        (event) async {
          if (event == AppStrings.deviceConnected) {
            await Future.delayed(Duration(milliseconds: 100));
            getStatus();
          } else {
            List<String> splitedString = event.split(' ').toList();

            switch (event.substring(0, 3)) {
              case 'GSM':
                {
                  _mode = _parseCurrentMode(splitedString[1]);
                  break;
                }
              case 'GSL':
                {
                  _lampLightStatus = splitedString[1] == '1'
                      ? RgbLampLightStatus.on
                      : RgbLampLightStatus.off;
                  break;
                }
              case 'GSS':
                {
                  _parseCurrentParameters(splitedString);
                  break;
                }
              default:
                break;
            }
          }
          _lampUpdatesStreamController.sink.add('');
          log('Update from lamp: ${event.toString()}');
        },
      );
    }
  }

  RgbLampMode _parseCurrentMode(String mode) {
    switch (mode) {
      case '1':
        return RgbLampMode.rgb;
      case '2':
        return RgbLampMode.rgb;
      case '3':
        return RgbLampMode.color;
      case '7':
        return RgbLampMode.fire;

      default:
        return RgbLampMode.undefined;
    }
  }

  void _parseCurrentParameters(List<String> splitedString) {
    List<int> listOfParameters = [];
    if (splitedString.length == 7) {
      for (int i = 1; i < 6; i++) {
        listOfParameters.add(
          int.parse(splitedString[i]),
        );
      }

      switch (_mode) {
        case RgbLampMode.rgb:
          {
            _lastRecievedParameters = RGBModeParams(
              brightness: listOfParameters[0],
              whiteColor: listOfParameters[4],
              redColor: listOfParameters[1],
              greenColor: listOfParameters[2],
              blueColor: listOfParameters[3],
            );
            break;
          }
        case RgbLampMode.color:
          {
            _lastRecievedParameters = ColorModeParams(
              brightness: listOfParameters[0],
              whiteColor: listOfParameters[2],
              numberOfColor: listOfParameters[1],
            );
            break;
          }
        case RgbLampMode.fire:
          {
            _lastRecievedParameters = FireModeParams(
              brightness: listOfParameters[0],
              speed: listOfParameters[1],
              min: listOfParameters[2],
            );
            break;
          }

        default:
          {
            _lastRecievedParameters = null;
            break;
          }
      }
    }
  }

  Future<void> connectDevice(BluetoothDevice device) async {
    try {
      await _deviceService.connectDevice(device);
      _listenUpdatesFromLamp();
    } catch (e) {
      log(e.toString());
      _lampUpdatesSubscription?.cancel();
      _lampUpdatesSubscription = null;
    }
  }

  Future<void> disconnectDevice() async {
    try {
      await _deviceService.disconnect();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getStatus() async {
    return await _deviceService.sendData('\$1;');
  }

  Future<void> sendData(String data) async {
    return await _deviceService.sendData(data);
  }

  void close() {
    _lampUpdatesSubscription?.cancel();
    _lampUpdatesStreamController.close();
    _deviceService.close();
  }
}
