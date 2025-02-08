import 'package:chromo_digital/core/error/failure.dart';
import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:chromo_digital/core/services/storage/database/app_database_service.dart';
import 'package:chromo_digital/features/company/data/models/company.dart';
import 'package:injectable/injectable.dart';

abstract class CompanyRepository {
  Future<DataState<Company>> getCompany();

  Future<DataState<int>> saveCompany(Company item);

  Future<DataState<int>> updateCompany(Company item);
}

@LazySingleton(as: CompanyRepository)
class CompanyRepositoryImpl implements CompanyRepository {
  final AppDatabaseService _service;

  CompanyRepositoryImpl(this._service);

  @override
  Future<DataState<Company>> getCompany() async {
    try {
      List<Map<String, Object?>> result = await _service.read('SELECT * FROM ${_service.company} ORDER BY createdAt DESC LIMIT 1;');
      if (result.isNotEmpty) {
        return DataSuccess(Company.fromJson(result.first as Map<String, dynamic>));
      } else {
        return DataFailed(NoDataFailure(message: 'No company data found'));
      }
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed(UnknownFailure(message: e.toString(), stackTrace: s));
    }
  }

  @override
  Future<DataState<int>> saveCompany(Company item) async {
    try {
      int result = await _service.insert(_service.company, item.toJson());
      return DataSuccess(result);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed(UnknownFailure(message: e.toString(), stackTrace: s));
    }
  }

  @override
  Future<DataState<int>> updateCompany(Company item) async {
    try {
      int result = await _service.update(_service.company, item.toJson(), where: 'id = ?', whereArgs: [item.id]);
      return DataSuccess(result);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed(UnknownFailure(message: e.toString(), stackTrace: s));
    }
  }
}
