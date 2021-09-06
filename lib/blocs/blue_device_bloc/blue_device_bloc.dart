import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:rgb_lamp_control/services/blue_device/blue_device_service.dart';

part 'blue_device_state.dart';
part 'blue_device_event.dart';

class BlueDeviceBloc extends Bloc<BlueDeviceEvent, BlueDeviceState> {
  final BlueDeviceService deviceService;
  late BluetoothDevice _device;
  StreamSubscription? _deviceUpdatesSubscription;

  BlueDeviceBloc({
    required this.deviceService,
  }) : super(BlueDeviceInitial()) {
    setSubscription();
  }

  @override
  Stream<BlueDeviceState> mapEventToState(event) async* {
    try {
      if (event is BlueDeviceConnect) {
        _device = event.device;
        await deviceService.connectDevice(_device);
        add(BlueDeviceUpdate());
      }
      if (event is BlueDeviceSwitchLight) {
        String sendMessage = '';
        if (deviceService.isLedEnabled) {
          sendMessage = '\$5,0;';
        } else {
          sendMessage = '\$5,1;';
        }
        deviceService.sendData(sendMessage);
        deviceService.sendData('\$1;');
      }
      if (event is BlueDeviceUpdate) {
        yield BlueDeviceConnected(
          isLedEnabled: deviceService.isLedEnabled,
          mode: deviceService.mode,
          parameters: deviceService.lastRecievedParameters,
        );
      }
      if (event is BlueDeviceChangeMode) {
        deviceService.setMode(event.mode);
      }
    } catch (e) {
      print("\n\n\n\Error from Device Bloc: $e\n\n\n");
    }
  }

/*   Future<void> _checkIfDeviceConnected() async {
    if (!deviceService.isConnected) {
      List<BluetoothDevice> connectedDevices =
          await getIt<FlutterBlue>().connectedDevices;
      for (var dev in connectedDevices) {
        if (dev.name == 'RGB Contoller') {
          deviceService.connectDevice(dev);
        }
      }
    }
  } */

  void setSubscription() {
    _deviceUpdatesSubscription = deviceService.recievedValueStream.listen((_) {
      add(BlueDeviceUpdate());
    });
  }

  @override
  Future<void> close() {
    _deviceUpdatesSubscription?.cancel();
    return super.close();
  }
}
