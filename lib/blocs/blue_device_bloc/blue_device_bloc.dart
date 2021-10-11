import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/models/found_bluetooth_device.dart';
import 'package:rgb_lamp_control/services/repositories/rgb_lamp_repo.dart';

part 'blue_device_event.dart';
part 'blue_device_state.dart';

class BlueDeviceBloc extends Bloc<BlueDeviceEvent, BlueDeviceState> {
  BlueDeviceBloc(this._rgbLampRepo) : super(BlueDeviceUnavailable()) {
    _listenFoundDevices();
  }
  final RgbLampRepo _rgbLampRepo;

  List<FoundDevice> _foundDevices = [];

  bool _isScanEmpty = false;
  bool _isScanStarted = false;

  @override
  Stream<BlueDeviceState> mapEventToState(event) async* {
    if (event is BlueDeviceStartScanEvent) {
      _startScanning();
      if (_foundDevices.isNotEmpty) {
        yield BlueDeviceFound(_foundDevices);
      } else {
        yield BlueDeviceSearching();
      }
    }
    if (event is BlueDeviceUpdateEvent) {
      if (_foundDevices.isEmpty && !_isScanEmpty) {
        _isScanEmpty = true;
        yield BlueDeviceUnavailable();
      } else if (_foundDevices.isNotEmpty) {
        yield BlueDeviceFound(
          _foundDevices,
          isStillSearching: _isScanStarted,
        );
      }
    }
  }

  void _startScanning() {
    int durationInSeconds = 4;
    _isScanStarted = true;
    Timer(
      Duration(seconds: durationInSeconds),
      () {
        if (_foundDevices.isEmpty) {
          _isScanEmpty = false;
        }
        _isScanStarted = false;
        add(BlueDeviceUpdateEvent());
      },
    );
    _rgbLampRepo.startScanning(durationInSeconds);
  }

  void _listenFoundDevices() {
    _rgbLampRepo.foundDevicesStream.listen(
      (devices) {
        _foundDevices = devices;
        add(BlueDeviceUpdateEvent());
      },
    );
  }
}
