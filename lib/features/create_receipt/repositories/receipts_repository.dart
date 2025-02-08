import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/core/services/storage/database/app_database_service.dart';
import 'package:chromo_digital/features/create_receipt/data/models/receipt/receipt.dart';
import 'package:injectable/injectable.dart';

import '../../../core/services/logger/logger.dart';

abstract class ReceiptsRepository {
  Future<DataState<List<Receipt>>> getAllReceipts();

  Future<DataState<int>> saveReceipt(Receipt item);

  Future<DataState<int>> deleteReceipt(int receiptId);
}

@LazySingleton(as: ReceiptsRepository)
class ReceiptsRepositoryImpl implements ReceiptsRepository {
  final AppDatabaseService _databaseService;

  ReceiptsRepositoryImpl(this._databaseService);

  @override
  Future<DataState<List<Receipt>>> getAllReceipts() async {
    try {
      // sort by createdAt new at top
      String query = 'SELECT * FROM ${_databaseService.receipts} ORDER BY createdAt DESC';

      List<Map<String, Object?>> result = await _databaseService.read(query);
      List<Receipt> items = [];
      result.map((e) {
        items.add(Receipt.fromJson(e as Map<String, dynamic>));
      }).toList();
      Log.d(runtimeType, 'getAllReceipts: ${items.length}');
      return DataSuccess(items);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }

  @override
  Future<DataState<int>> saveReceipt(Receipt item) async {
    try {
      int result = await _databaseService.insert(_databaseService.receipts, item.toJson());
      return DataSuccess(result);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }

  @override
  Future<DataState<int>> deleteReceipt(int receiptId) async {
    try {
      await _databaseService.delete(_databaseService.receipts, where: 'id = ?', whereArgs: [receiptId]);
      return DataSuccess(receiptId);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }
}
