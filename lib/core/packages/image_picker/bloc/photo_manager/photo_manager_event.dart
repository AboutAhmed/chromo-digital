part of 'photo_manager_bloc.dart';

@immutable
sealed class GalleryManagerEvent {}

class FetchAssetsEvent extends GalleryManagerEvent {
  final RequestType requestType;
  final int perPageItem;

  FetchAssetsEvent(this.requestType, this.perPageItem);
}

class NextPageEvent extends GalleryManagerEvent {}

class RequestPermissionEvent extends GalleryManagerEvent {}
