import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:chromo_digital/core/services/storage/database/app_database_service.dart';
import 'package:chromo_digital/features/create_receipt/data/models/purpose/purpose.dart';
import 'package:injectable/injectable.dart';

abstract class PurposeRepository {
  Future<DataState<List<Purpose>>> getAllPurposes();

  Future<DataState<int>> savePurpose(Purpose item);

  Future<DataState<int>> updatePurpose(Purpose item);

  Future<DataState<int>> deletePurpose(int id);
}

@LazySingleton(as: PurposeRepository)
class PurposeRepositoryImpl implements PurposeRepository {
  final AppDatabaseService _databaseService;

  PurposeRepositoryImpl(this._databaseService);

  @override
  Future<DataState<List<Purpose>>> getAllPurposes() async {
    try {
      String query = 'Select * from ${_databaseService.purposes}';
      List<Map<String, Object?>> result = await _databaseService.read(query);
      List<Purpose> items = result.map((e) => Purpose.fromJson(e as Map<String, dynamic>)).toList();
      return DataSuccess(items);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }

  @override
  Future<DataState<int>> savePurpose(Purpose item) async {
    try {
      int result = await _databaseService.insert(_databaseService.purposes, item.toJson());
      return DataSuccess(result);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }

  @override
  Future<DataState<int>> deletePurpose(int id) async {
    try {
      int value = await _databaseService.delete(_databaseService.purposes, where: 'id = ?', whereArgs: [id]);
      return DataSuccess(value);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }

  @override
  Future<DataState<int>> updatePurpose(Purpose item) async {
    try {
      int result = await _databaseService.update(_databaseService.purposes, item.toJson(), where: 'id = ?', whereArgs: [item.id]);
      return DataSuccess(result);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }
}
