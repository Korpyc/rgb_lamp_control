import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:rgb_lamp_control/services/services.dart';

part 'blue_adapter_state.dart';

class BlueAdapterCubit extends Cubit<BlueAdapterState> {
  BlueAdapterCubit() : super(BlueAdapterInitial()) {
    _getBlueState();
  }

  late StreamSubscription _blueSubscription;

  void _getBlueState() {
    _blueSubscription = getIt<FlutterBlue>().state.listen((event) {
      if (event == BluetoothState.off) {
        emit(BlueOFFState());
      }
      if (event == BluetoothState.on) {
        emit(BlueOnState());
      }
      if (event == BluetoothState.unavailable) {
        emit(BlueNotAvailableState());
      }
      if (event == BluetoothState.unknown) {
        emit(BlueErrorState());
      }
      if (event == BluetoothState.unauthorized) {
        emit(BlueUnauthorizedState());
      }
    });
  }

  @override
  Future<void> close() {
    _blueSubscription.cancel();
    return super.close();
  }
}
