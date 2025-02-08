import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class GalleryManagerService {
  Future<DataState<List<AssetEntity>>> getAssetListPaged(RequestType requestType, int page, int perPage);

  Future<DataState<PermissionState>> requestPermissionExtend();
}
