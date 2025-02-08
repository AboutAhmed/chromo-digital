import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/error/failure.dart';
import 'package:chromo_digital/core/packages/image_picker/image_picker.dart';
import 'package:chromo_digital/core/packages/image_picker/service/gallery_manager/gallery_manager_service.dart';
import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

part 'photo_manager_event.dart';
part 'photo_manager_state.dart';

@Injectable()
class GalleryManagerBloc extends Bloc<GalleryManagerEvent, GalleryManagerState> {
  final GalleryManagerService _photoManagerService;

  GalleryManagerBloc(this._photoManagerService) : super(const GalleryManagerInitial()) {
    on<FetchAssetsEvent>(_fetchPhotos);
    on<NextPageEvent>(_fetchNextPhotos, transformer: droppable());
    on<RequestPermissionEvent>(_requestPermission);
  }

  FutureOr<void> _fetchPhotos(FetchAssetsEvent event, Emitter<GalleryManagerState> emit) async {
    PermissionState? permission = await _checkPermission();
    if (permission == null) {
      emit(
        GalleryManagerFailed(
          message: AppStrings.somethingWentWrong,
          page: state.page,
          perPage: state.perPage,
          hasReachedMax: state.hasReachedMax,
          requestType: event.requestType,
        ),
      );
      return;
    }
    if (permission.hasAccess) {
      emit(
        GalleryManagerLoading(
          items: [...state.items],
          page: state.page,
          perPage: state.perPage,
          hasReachedMax: state.hasReachedMax,
          requestType: event.requestType,
        ),
      );
      DataState<List<AssetEntity>> result = await _photoManagerService.getAssetListPaged(state.requestType, state.page, state.perPage);
      result.when(
        success: (data) {
          emit(
            GalleryManagerLoaded(
              items: [...data],
              page: state.page,
              perPage: state.perPage,
              hasReachedMax: data.length < state.perPage,
              requestType: state.requestType,
            ),
          );
        },
        onError: (Failure failure) {
          emit(
            GalleryManagerFailed(
              message: failure.message,
              failure: failure,
              page: state.page,
              perPage: state.perPage,
              hasReachedMax: state.hasReachedMax,
              requestType: state.requestType,
              items: [...state.items],
            ),
          );
        },
      );
    } else {
      emit(
        GalleryManagerPermissionState(
          permission: permission,
          page: state.page,
          perPage: state.perPage,
          hasReachedMax: state.hasReachedMax,
          items: [...state.items],
          requestType: state.requestType,
        ),
      );
    }
  }

  Future<void> _fetchNextPhotos(NextPageEvent event, Emitter<GalleryManagerState> emit) async {
    if (state.hasReachedMax) return Future.delayed(Duration.zero);
    PermissionState? permission = await _checkPermission();
    if (permission == null) {
      emit(
        GalleryManagerFailed(
          message: AppStrings.somethingWentWrong,
          page: state.page,
          perPage: state.perPage,
          hasReachedMax: state.hasReachedMax,
          items: [...state.items],
          requestType: state.requestType,
        ),
      );
      return Future.delayed(Duration.zero);
    }
    if (permission.hasAccess) {
      int page = state.page + 1;
      emit(
        GalleryManagerLoading(
          items: [...state.items],
          page: page,
          perPage: state.perPage,
          hasReachedMax: state.hasReachedMax,
          requestType: state.requestType,
        ),
      );
      DataState<List<AssetEntity>> result = await _photoManagerService.getAssetListPaged(state.requestType, state.page, state.perPage);
      result.when(
        success: (data) {
          emit(
            GalleryManagerLoaded(
              items: [...state.items, ...data],
              page: state.page,
              perPage: state.perPage,
              hasReachedMax: data.length < state.perPage,
              requestType: state.requestType,
            ),
          );
        },
        onError: (Failure failure) {
          emit(
            GalleryManagerFailed(
              message: failure.message,
              failure: failure,
              page: state.page,
              perPage: state.perPage,
              hasReachedMax: state.hasReachedMax,
              items: [...state.items],
            ),
          );
        },
      );
    } else {
      emit(
        GalleryManagerPermissionState(
          permission: permission,
          page: state.page,
          perPage: state.perPage,
          hasReachedMax: state.hasReachedMax,
          items: [...state.items],
          requestType: state.requestType,
        ),
      );
    }
  }

  FutureOr<void> _requestPermission(RequestPermissionEvent event, Emitter<GalleryManagerState> emit) {
    emit(
      GalleryManagerLoading(
        items: [...state.items],
        page: state.page,
        perPage: state.perPage,
        hasReachedMax: state.hasReachedMax,
        requestType: state.requestType,
      ),
    );
    _checkPermission().then((permission) {
      if (permission == null) {
        emit(
          GalleryManagerFailed(
            message: AppStrings.somethingWentWrong,
            page: state.page,
            perPage: state.perPage,
            hasReachedMax: state.hasReachedMax,
            requestType: state.requestType,
            items: [...state.items],
          ),
        );
        return;
      }
      if (permission.hasAccess) {
        _fetchPhotos(FetchAssetsEvent(state.requestType, state.perPage), emit);
      } else {
        emit(
          GalleryManagerPermissionState(
            permission: permission,
            page: state.page,
            perPage: state.perPage,
            hasReachedMax: state.hasReachedMax,
            items: [...state.items],
            requestType: state.requestType,
          ),
        );
      }
    });
  }

  Future<PermissionState?> _checkPermission() async {
    DataState<PermissionState> result = await _photoManagerService.requestPermissionExtend();
    if (result is DataSuccess) return result.data;
    return null;
  }
}
