import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:rgb_lamp_control/models/found_bluetooth_device.dart';
import 'package:rgb_lamp_control/services/repositories/blue_search_repo.dart';

part 'blue_search_event.dart';
part 'blue_search_state.dart';

class BlueSearchBloc extends Bloc<BlueSearchEvent, BlueSearchState> {
  final BlueSearchRepo _blueSearchRepo;

  StreamSubscription? _searchSubscription;

  List<FoundDevice> _foundDevices = [];

  bool _isScanEmpty = false;
  bool _isScanStarted = false;

  BlueSearchBloc(this._blueSearchRepo) : super(BlueDeviceSearching()) {
    _listenFoundDevices();
    _startScanning();
    on<BlueSearchEvent>(
      (event, emit) {
        if (event is BlueDeviceStartScanEvent) {
          _startScanning();
          if (_foundDevices.isNotEmpty) {
            emit(BlueDeviceFound(
              _foundDevices,
              isStillSearching: _isScanStarted,
            ));
          } else {
            emit(BlueDeviceSearching());
          }
        }
        if (event is BlueDeviceUpdateEvent) {
          if (_foundDevices.isEmpty && !_isScanEmpty) {
            _isScanEmpty = true;
            emit(BlueDeviceUnavailable());
          } else if (_foundDevices.isNotEmpty) {
            emit(
              BlueDeviceFound(
                _foundDevices,
                isStillSearching: _isScanStarted,
              ),
            );
          }
        }
      },
    );
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
    _blueSearchRepo.startScanning(durationInSeconds);
  }

  void _listenFoundDevices() {
    if (_searchSubscription == null) {
      _searchSubscription = _blueSearchRepo.foundDevicesStream.listen(
        (devices) {
          _foundDevices = devices;
          add(BlueDeviceUpdateEvent());
        },
      );
    }
  }

  @override
  Future<void> close() {
    _searchSubscription?.cancel();
    return super.close();
  }
}
