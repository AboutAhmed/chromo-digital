part of 'photo_manager_bloc.dart';

@immutable
sealed class GalleryManagerState {
  final int page;
  final List<AssetEntity> items;
  final int perPage;
  final bool hasReachedMax;
  final RequestType requestType;

  const GalleryManagerState({
    this.page = 0,
    this.items = const [],
    this.perPage = perPageItem,
    this.hasReachedMax = false,
    this.requestType = RequestType.image,
  });

  GalleryManagerState copyWith({
    int? page,
    List<AssetEntity>? items,
    int? perPage,
    bool? hasReachedMax,
    RequestType? requestType,
  });
}

final class GalleryManagerInitial extends GalleryManagerState {
  const GalleryManagerInitial({
    super.page,
    super.items,
    super.perPage,
    super.hasReachedMax,
    super.requestType,
  });

  @override
  GalleryManagerState copyWith({
    int? page,
    List<AssetEntity>? items,
    int? perPage,
    bool? hasReachedMax,
    RequestType? requestType,
  }) {
    return GalleryManagerInitial(
      page: page ?? super.page,
      items: items ?? super.items,
      perPage: perPage ?? super.perPage,
      hasReachedMax: hasReachedMax ?? super.hasReachedMax,
      requestType: requestType ?? super.requestType,
    );
  }
}

final class GalleryManagerLoading extends GalleryManagerState {
  const GalleryManagerLoading({
    super.page,
    super.items,
    super.perPage,
    super.hasReachedMax,
    super.requestType,
  });

  @override
  GalleryManagerState copyWith({
    int? page,
    List<AssetEntity>? items,
    int? perPage,
    bool? hasReachedMax,
    RequestType? requestType,
  }) {
    return GalleryManagerLoading(
      page: page ?? super.page,
      items: items ?? super.items,
      perPage: perPage ?? super.perPage,
      hasReachedMax: hasReachedMax ?? super.hasReachedMax,
      requestType: requestType ?? super.requestType,
    );
  }
}

final class GalleryManagerLoaded extends GalleryManagerState {
  const GalleryManagerLoaded({
    super.page,
    super.items,
    super.perPage,
    super.hasReachedMax,
    super.requestType,
  });

  @override
  GalleryManagerState copyWith({
    int? page,
    List<AssetEntity>? items,
    int? perPage,
    bool? hasReachedMax,
    RequestType? requestType,
  }) {
    return GalleryManagerLoaded(
      page: page ?? super.page,
      items: items ?? super.items,
      perPage: perPage ?? super.perPage,
      hasReachedMax: hasReachedMax ?? super.hasReachedMax,
      requestType: requestType ?? super.requestType,
    );
  }
}

final class GalleryManagerFailed extends GalleryManagerState {
  final String message;
  final Failure? failure;

  const GalleryManagerFailed({
    super.page,
    super.items,
    super.perPage,
    super.hasReachedMax,
    super.requestType,
    required this.message,
    this.failure,
  });

  @override
  GalleryManagerState copyWith({
    int? page,
    List<AssetEntity>? items,
    int? perPage,
    bool? hasReachedMax,
    RequestType? requestType,
  }) {
    return GalleryManagerFailed(
      page: page ?? super.page,
      items: items ?? super.items,
      perPage: perPage ?? super.perPage,
      hasReachedMax: hasReachedMax ?? super.hasReachedMax,
      requestType: requestType ?? super.requestType,
      message: message,
      failure: failure,
    );
  }
}

final class GalleryManagerPermissionState extends GalleryManagerState {
  final PermissionState permission;

  const GalleryManagerPermissionState({
    super.page,
    super.items,
    super.perPage,
    super.hasReachedMax,
    super.requestType,
    required this.permission,
  });

  @override
  GalleryManagerPermissionState copyWith({
    int? page,
    List<AssetEntity>? items,
    int? perPage,
    bool? hasReachedMax,
    RequestType? requestType,
  }) {
    return GalleryManagerPermissionState(
      page: page ?? super.page,
      items: items ?? super.items,
      perPage: perPage ?? super.perPage,
      hasReachedMax: hasReachedMax ?? super.hasReachedMax,
      permission: permission,
      requestType: requestType ?? super.requestType,
    );
  }
}
