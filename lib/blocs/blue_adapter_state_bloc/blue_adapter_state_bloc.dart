import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:rgb_lamp_control/services/services.dart';

part 'blue_adapter_state_state.dart';
part 'blue_adapter_state_event.dart';

class BlueAdapterStateBloc extends Bloc<BlueAdapterEvent, BlueAdapterState> {
  BlueAdapterStateBloc() : super(BlueOFFState()) {
    _getBlueState();
  }

  late StreamSubscription _blueAdapterEventsSubscription;

  @override
  Stream<BlueAdapterState> mapEventToState(event) async* {
    if (event is BlueAdapterUpdateEvent) {
      if (event.blueAdapterState == BluetoothState.on) {
        yield BlueAdapterOnState();
      } else if (event.blueAdapterState == BluetoothState.unavailable) {
        yield BlueNotAvailableState();
      } else if (event.blueAdapterState == BluetoothState.unknown) {
        yield BlueErrorState();
      } else if (event.blueAdapterState == BluetoothState.unauthorized) {
        yield BlueUnauthorizedState();
      } else {
        yield BlueOFFState();
      }
    }
  }

  void _getBlueState() {
    _blueAdapterEventsSubscription = getIt<FlutterBlue>().state.listen(
      (event) {
        add(BlueAdapterUpdateEvent(event));
      },
    );
  }

  @override
  Future<void> close() {
    _blueAdapterEventsSubscription.cancel();
    return super.close();
  }
}
