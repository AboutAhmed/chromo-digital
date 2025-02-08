import 'dart:io';

import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import 'camera_service.dart';

@LazySingleton(as: CameraService)
class CameraServiceImpl extends CameraService {
  CameraServiceImpl();

  final ImagePicker _picker = ImagePicker();

  @override
  Future<File?> recordVideo() async {
    try {
      XFile? result = await _picker.pickVideo(source: ImageSource.camera);
      if (result == null) return null;
      return File(result.path);
    } catch (e, s) {
      Log.e(runtimeType, e, s);
    }
    return null;
  }

  @override
  Future<File?> takePhoto() async {
    try {
      XFile? result = await _picker.pickImage(source: ImageSource.camera);
      if (result == null) return null;
      return File(result.path);
    } catch (e, s) {
      Log.e(runtimeType, e, s);
    }
    return null;
  }
}
