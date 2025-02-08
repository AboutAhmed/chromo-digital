part of '../image_picker.dart';

enum _CameraSource { video, image }

class _CameraAction extends StatelessWidget {
  final _CameraSource action;
  final CameraService? service;
  final ValueChanged<File>? onResult;

  _CameraAction({
    this.action = _CameraSource.image,
    this.service,
    this.onResult,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _validatePermission(context),
      child: Ink(
        color: context.primary.withValues(alpha: 255 * 0.05),
        child: Icon(
          action == _CameraSource.image ? LucideIcons.camera : LucideIcons.video,
          size: 36.0,
          color: context.onPrimary,
        ).center(),
      ),
    );
  }

  final PermissionService _permissionService = sl<PermissionService>();

  Future<void> _validatePermission(BuildContext context) async {
    _permissionService.requestPermission(Permission.camera).then((result) {
      if (result.isGranted) {
        _attemptCameraAction();
      } else if (result.isPermanentlyDenied) {
        if (context.mounted) {
          context.showAppGeneralDialog(
            child: EmptyState.fail(
              icon: Icon(LucideIcons.camera, size: 80.0, color: context.primary),
              title: const Text(AppStrings.permissionDenied).tr(),
              subtitle: const Text(AppStrings.permissionDeniedMessage).tr(),
              action: TextButton(
                onPressed: _permissionService.openAppSettings,
                child: const Text(AppStrings.openSettings).tr(),
              ),
            ),
            title: AppStrings.permissionDenied.tr(),
          );
        }
      }
    });
  }

  Future<void> _attemptCameraAction() async {
    File? file;
    if (action == _CameraSource.image) {
      file = await service?.takePhoto();
    } else {
      file = await service?.recordVideo();
    }
    if (file != null) {
      onResult?.call(file);
    }
  }
}
