import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'blue_device_state.dart';

class BlueDeviceBloc extends Cubit<BlueDeviceState> {
  BlueDeviceBloc() : super(BlueDeviceInitial());

  late StreamSubscription _blueDeviceSubscription;

  @override
  Future<void> close() {
    _blueDeviceSubscription.cancel();
    return super.close();
  }
}
