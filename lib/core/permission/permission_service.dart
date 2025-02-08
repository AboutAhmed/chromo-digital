import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;

@LazySingleton()
class PermissionService {
  PermissionService();

  Future<bool> isGranted(permission_handler.Permission permission) async => await permission.isGranted;

  Future<bool> isDenied(permission_handler.Permission permission) async => await permission.isDenied;

  Future<bool> isPermanentlyDenied(permission_handler.Permission permission) async => await permission.isPermanentlyDenied;

  Future<bool> isRestricted(permission_handler.Permission permission) async => await permission.isRestricted;

  Future<bool> isLimited(permission_handler.Permission permission) async => await permission.isLimited;

  Future<bool> isProvisional(permission_handler.Permission permission) async => await permission.isProvisional;

  Future<bool> shouldShowRequestRationale(permission_handler.Permission permission) async => await permission.shouldShowRequestRationale;

  Future<Map<permission_handler.Permission, permission_handler.PermissionStatus>> requestPermissions(List<permission_handler.Permission> permissions) async => await permissions.request();

  Future<permission_handler.PermissionStatus> requestPermission(permission_handler.Permission permission) async => await permission.request();

  Future<bool> openAppSettings() async => permission_handler.openAppSettings();
}
