import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:rgb_lamp_control/services/repositories/rgb_lamp_repo.dart';

part 'blue_device_event.dart';
part 'blue_device_state.dart';

class BlueDeviceBloc extends Bloc<BlueDeviceEvent, BlueDeviceState> {
  final RgbLampRepo _rgbLampRepo;

  StreamSubscription? _lampUpdatesSubscription;
  BlueDeviceBloc(this._rgbLampRepo) : super(BlueDeviceInitial()) {
    on<BlueDeviceEvent>(
      (event, emit) async {
        if (event is BlueDeviceRequestConnect) {
          await _connectDevice(event.device);
        } else if (event is BlueDeviceUpdateEvent) {
          if (_rgbLampRepo.isDeviceConnected) {
            emit(
              BlueDeviceConnected(
                isLampOn: _rgbLampRepo.isLampOn,
                mode: _rgbLampRepo.currentMode,
              ),
            );
          } else {
            emit(BlueDeviceDisconnected());
          }
        } else if (event is BlueDeviceDisconnectEvent) {
          await _disconnectDevice();
        } else if (event is BlueDeviceLightSwitchEvent) {
          _rgbLampRepo.lightSwitch();
        }
      },
    );
  }

  Future<void> _listenLampUpdates() async {
    if (_lampUpdatesSubscription == null) {
      _lampUpdatesSubscription = _rgbLampRepo.lampUpdates.listen((_) {
        add(BlueDeviceUpdateEvent());
      });
    }
  }

  Future<void> _connectDevice(BluetoothDevice device) async {
    try {
      await _listenLampUpdates();
      _rgbLampRepo.connectDevice(device);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _disconnectDevice() async {
    try {
      await _rgbLampRepo.disconnectDevice();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> close() {
    _lampUpdatesSubscription?.cancel();
    _rgbLampRepo.close();
    return super.close();
  }
}
