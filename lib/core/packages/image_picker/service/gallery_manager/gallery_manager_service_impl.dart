import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

import 'gallery_manager_service.dart';

@LazySingleton(as: GalleryManagerService)
class GalleryManagerServiceImpl implements GalleryManagerService {
  @override
  Future<DataState<List<AssetEntity>>> getAssetListPaged(RequestType requestType, int page, int perPage) async {
    try {
      List<AssetEntity> items = await PhotoManager.getAssetListPaged(
        type: requestType,
        page: page,
        pageCount: perPage,
      );
      return DataSuccess(items);
    } catch (e, s) {
      return DataFailed.unknown(s: s);
    }
  }

  @override
  Future<DataState<PermissionState>> requestPermissionExtend() async {
    try {
      PermissionState state = await PhotoManager.requestPermissionExtend();
      return DataSuccess(state);
    } catch (e, s) {
      return DataFailed.unknown(s: s);
    }
  }
}
