import 'dart:io';

import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/extensions/build_context_extension.dart';
import 'package:chromo_digital/core/packages/image_picker/bloc/photo_manager/photo_manager_bloc.dart';
import 'package:chromo_digital/core/packages/image_picker/bloc/selection_handler/selection_handler_cubit.dart';
import 'package:chromo_digital/core/packages/image_picker/service/camera_service/camera_service.dart';
import 'package:chromo_digital/core/packages/image_picker/widgets/gallery_asset_viewer.dart';
import 'package:chromo_digital/core/permission/permission_service.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:chromo_digital/core/widgets/empty_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

part 'widgets/camera_action.dart';

/// avoid to changed these value and
/// in case you've a different requirement
/// you can change it in the openGallery method by passing custom value
const maxImagesLimit = 2;
const maxVideosLimit = 1;
const perPageItem = 66;
const List<RequestType> requestTypes = [RequestType.image];
const photosMultiSelection = true;
const videosMultiSelection = true;

// on selection done
typedef OnSelectionDone = void Function(List<File> photos, List<File> videos);
typedef OnPhotoSelection = void Function(List<File> photos);

Future<File?> openCamera() => sl<CameraService>().takePhoto();

/// open photo picker
Future openPhotoPicker(
  final BuildContext context, {
  final List<File>? initialValue,
  final bool multiSelection = false,
  final int maxImagesLimit = maxImagesLimit,
  final OnPhotoSelection? onResult,
}) {
  return openGallery(
    context,
    requestTypes: [RequestType.image],
    photosMultiSelection: multiSelection,
    maxImagesLimit: maxImagesLimit,
    initialSelectedPhotos: initialValue,
    onResult: (photos, _) => onResult?.call(photos),
  );
}

Future openGallery(
  final BuildContext context, {
  final List<RequestType> requestTypes = requestTypes,
  final bool videosMultiSelection = videosMultiSelection,
  final bool photosMultiSelection = photosMultiSelection,
  final int maxImagesLimit = maxImagesLimit,
  final int maxVideosLimit = maxVideosLimit,
  final List<File>? initialSelectedPhotos,
  final List<File>? initialSelectedVideos,
  final OnSelectionDone? onResult,
}) {
  assert(requestTypes.isNotEmpty, 'Request types cannot be empty');
  assert(requestTypes.length <= 2, 'Request types cannot be more than 2');
  assert(requestTypes.every((e) => e == RequestType.video || e == RequestType.image), 'Request types can only be video or image nothing else');
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.85,
        minChildSize: 0.85,
        expand: true,
        builder: (_, __) => _ImagePicker(
          requestTypes: requestTypes,
          initialSelectedPhotos: initialSelectedPhotos,
          initialSelectedVideos: initialSelectedVideos,
          videosMultiSelection: videosMultiSelection,
          photosMultiSelection: photosMultiSelection,
          imagesLimit: maxImagesLimit,
          videosLimit: maxVideosLimit,
          onResult: onResult,
        ),
      );
    },
  );
}

class _ImagePicker extends StatefulWidget {
  final List<RequestType> requestTypes;
  final List<File> initialSelectedPhotos;
  final List<File> initialSelectedVideos;
  final OnSelectionDone? onResult;

  // bool multiSelection = false
  // int maxImagesLimit = 5
  // int maxVideosLimit = 5
  final bool videosMultiSelection;
  final bool photosMultiSelection;
  final int imagesLimit;
  final int videosLimit;

  const _ImagePicker({
    required this.requestTypes,
    final List<File>? initialSelectedPhotos,
    final List<File>? initialSelectedVideos,
    this.videosMultiSelection = false,
    this.photosMultiSelection = false,
    this.imagesLimit = maxImagesLimit,
    this.videosLimit = maxVideosLimit,
    this.onResult,
  })  : initialSelectedPhotos = initialSelectedPhotos ?? const [],
        initialSelectedVideos = initialSelectedVideos ?? const [];

  @override
  State<_ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<_ImagePicker> with SingleTickerProviderStateMixin {
  final GalleryManagerBloc _photosManagerBloc = sl<GalleryManagerBloc>();
  final GalleryManagerBloc _videosManagerBloc = sl<GalleryManagerBloc>();
  final SelectionHandlerCubit _photosSelectionHandler = sl<SelectionHandlerCubit>();
  final SelectionHandlerCubit _videosSelectionHandler = sl<SelectionHandlerCubit>();
  final CameraService _cameraService = sl<CameraService>();
  late final TabController _tabController;
  ScrollController? _imageController;

  ScrollController? _videoController;

  @override
  void initState() {
    super.initState();

    /// assets bloc initialization and fetching from the gallery
    if (widget.requestTypes.any((e) => e == RequestType.video) && widget.requestTypes.any((e) => e == RequestType.image)) {
      _photosManagerBloc.add(FetchAssetsEvent(RequestType.image, perPageItem));
      _videosManagerBloc.add(FetchAssetsEvent(RequestType.video, perPageItem));
      _imageController = ScrollController();
      _videoController = ScrollController();
    } else if (widget.requestTypes.length == 1 && widget.requestTypes.first == RequestType.image) {
      _photosManagerBloc.add(FetchAssetsEvent(RequestType.image, perPageItem));
      _imageController = ScrollController();
    } else {
      _videosManagerBloc.add(FetchAssetsEvent(RequestType.video, perPageItem));
      _videoController = ScrollController();
    }

    /// tab controller in case of video and image
    _tabController = TabController(length: widget.requestTypes.length, vsync: this);

    /// listener for fetching next page
    _imageController?.addListener(() {
      if (_imageController?.position.pixels == _imageController?.position.maxScrollExtent) {
        _photosManagerBloc.add(NextPageEvent());
      }
    });

    /// listener for fetching next page
    _videoController?.addListener(() {
      if (_videoController?.position.pixels == _videoController?.position.maxScrollExtent) {
        _videosManagerBloc.add(NextPageEvent());
      }
    });

    /// selection handler initialization with initial selected photos and videos
    _photosSelectionHandler
      ..init(
        items: widget.initialSelectedPhotos,
        multiSelection: widget.photosMultiSelection && widget.imagesLimit > 1,
        maxItemsLimit: widget.imagesLimit,
      )
      ..stream.listen((state) {
        if (state.limitReached && widget.imagesLimit > 1) {
          if (mounted) {
            context.showToast(context.tr(AppStrings.youHaveReachedTheMaxLimit));
          }
        }
      });
    _videosSelectionHandler
      ..init(
        items: widget.initialSelectedVideos,
        multiSelection: widget.videosMultiSelection && widget.videosLimit > 1,
        maxItemsLimit: widget.videosLimit,
      )
      ..stream.listen((state) {
        if (state.limitReached && widget.videosLimit > 1) {
          if (mounted) context.showToast(context.tr(AppStrings.youHaveReachedTheMaxLimit));
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryManagerBloc, GalleryManagerState>(
      bloc: _photosManagerBloc,
      builder: (context, photoState) {
        return BlocBuilder<GalleryManagerBloc, GalleryManagerState>(
          bloc: _videosManagerBloc,
          builder: (context, videoState) {
            return DefaultTabController(
              length: _tabController.length,
              child: Container(
                decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadius.circular(16.0)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppButton.text(
                          foregroundColor: context.onPrimary,
                          child: const Text(AppStrings.cancel).tr(),
                          onPressed: () => Navigator.pop(context),
                        ).center().expanded(flex: 3),
                        Text(AppStrings.photos, style: context.titleMedium!, textAlign: TextAlign.center).tr().expanded(flex: 5),
                        AppButton.text(
                          onPressed: _onSelectionDone,
                          foregroundColor: context.onPrimary,
                          child: const Text(AppStrings.done).tr(),
                        ).center().expanded(flex: 3),
                      ],
                    ),
                    if (videoState is GalleryManagerPermissionState || photoState is GalleryManagerPermissionState)
                      EmptyState.fail(
                        icon: Icon(Icons.warning_amber_rounded, size: 80.0, color: context.error),
                        title: const Text(AppStrings.permissionDenied).tr(),
                        subtitle: const Text(AppStrings.permissionDeniedMessage).tr(),
                        action: AppButton.text(
                          child: const Text(AppStrings.openSettings).tr(),
                          onPressed: () => PhotoManager.openSetting(),
                        ),
                      ).center()
                    else if (widget.requestTypes.length == 2)
                      TabBar(
                        controller: _tabController,
                        labelStyle: context.titleMedium!,
                        unselectedLabelStyle: context.titleMedium!,
                        tabs: [
                          Tab(text: AppStrings.photos.tr()),
                          Tab(text: AppStrings.videos.tr()),
                        ],
                      ),
                    if (!(videoState is GalleryManagerPermissionState || photoState is GalleryManagerPermissionState))
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            if (widget.requestTypes.any((e) => e == RequestType.image))
                              GridView.builder(
                                controller: _imageController,
                                itemCount: photoState.items.length + 1,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 2.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == 0) {
                                    return _CameraAction(
                                      service: _cameraService,
                                      onResult: _photosSelectionHandler.addCameraFile,
                                    );
                                  }
                                  AssetEntity asset = photoState.items[index - 1];
                                  return GalleryAssetViewer(
                                    key: ValueKey(asset.id),
                                    asset,
                                    selectionHandler: _photosSelectionHandler,
                                  );
                                },
                              ),
                            if (widget.requestTypes.any((e) => e == RequestType.video))
                              GridView.builder(
                                controller: _videoController,
                                itemCount: videoState.items.length + 1,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 2.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == 0) {
                                    return _CameraAction(
                                      service: _cameraService,
                                      action: _CameraSource.video,
                                      onResult: _videosSelectionHandler.addCameraFile,
                                    );
                                  }
                                  AssetEntity asset = videoState.items[index - 1];
                                  return GalleryAssetViewer(
                                    asset,
                                    selectionHandler: _videosSelectionHandler,
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onSelectionDone() {
    widget.onResult?.call(_photosSelectionHandler.state.items, _videosSelectionHandler.state.items);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _photosManagerBloc.close();
    _videosManagerBloc.close();
    _tabController.dispose();
    _imageController?.dispose();
    _videoController?.dispose();
    _photosSelectionHandler.close();
    _videosSelectionHandler.close();
    super.dispose();
  }
}
