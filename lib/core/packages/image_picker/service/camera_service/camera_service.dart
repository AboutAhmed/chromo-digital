import 'dart:io';

abstract class CameraService {
  Future<File?> takePhoto();

  Future<File?> recordVideo();
}
