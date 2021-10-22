import 'package:rgb_lamp_control/services/repositories/rgb_lamp_repo.dart';

abstract class ControlService {
  final RgbLampRepo lampRepo;
  ControlService(
    this.lampRepo,
  );

  Future<void> sendParams();
}
