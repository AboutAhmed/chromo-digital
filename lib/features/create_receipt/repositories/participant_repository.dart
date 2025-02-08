import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:chromo_digital/core/services/storage/database/app_database_service.dart';
import 'package:chromo_digital/features/create_receipt/data/models/Participant/participants.dart';
import 'package:injectable/injectable.dart';

abstract class ParticipantsRepository {
  Future<DataState<List<Participant>>> getAllParticipants();

  Future<DataState<int>> saveParticipant(Participant item);

  Future<DataState<List<int>>> saveParticipants(List<Participant> items);

  Future<DataState<int>> updateParticipant(Participant item);

  Future<DataState<int>> deleteParticipant(int id);
}

@LazySingleton(as: ParticipantsRepository)
class ParticipantRepositoryImpl implements ParticipantsRepository {
  final AppDatabaseService _databaseService;

  ParticipantRepositoryImpl(this._databaseService);

  @override
  Future<DataState<List<Participant>>> getAllParticipants() async {
    try {
      String query = 'SELECT * FROM ${_databaseService.participants}';
      List<Map<String, Object?>> result = await _databaseService.read(query);

      List<Participant> items = result.map((e) {
        return Participant.fromJson(e as Map<String, dynamic>);
      }).toList();

      return DataSuccess(items);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }

  @override
  Future<DataState<int>> saveParticipant(Participant item) async {
    try {
      int result = await _databaseService.insert(_databaseService.participants, item.toJson());
      return DataSuccess(result);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }

  @override
  Future<DataState<List<int>>> saveParticipants(List<Participant> items) async {
    try {
      List<int> result = await _databaseService.batchInsert(_databaseService.participants, items.map((e) => e.toJson()).toList());
      return DataSuccess(result);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }

  @override
  Future<DataState<int>> deleteParticipant(int id) async {
    try {
      int value = await _databaseService.delete(_databaseService.participants, where: 'id = ?', whereArgs: [id]);
      return DataSuccess(value);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }

  @override
  Future<DataState<int>> updateParticipant(Participant item) async {
    try {
      int result = await _databaseService.update(_databaseService.participants, item.toJson(), where: 'id = ?', whereArgs: [item.id]);
      return DataSuccess(result);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }
}
