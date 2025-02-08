import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:chromo_digital/core/services/storage/database/app_database_service.dart';
import 'package:chromo_digital/features/create_receipt/data/models/restaurant/restaurant.dart';
import 'package:injectable/injectable.dart';

abstract class RestaurantRepository {
  Future<DataState<List<Restaurant>>> getAllRestaurants();

  Future<DataState<int>> saveRestaurant(Restaurant item);

  Future<DataState<int>> updateRestaurant(Restaurant item);

  Future<DataState<int>> deleteRestaurant(int id);
}

@LazySingleton(as: RestaurantRepository)
class RestaurantRepositoryImpl implements RestaurantRepository {
  final AppDatabaseService _databaseService;

  RestaurantRepositoryImpl(this._databaseService);

  @override
  Future<DataState<List<Restaurant>>> getAllRestaurants() async {
    try {
      String query = 'SELECT * FROM ${_databaseService.restaurants}';
      List<Map<String, Object?>> result = await _databaseService.read(query);
      List<Restaurant> items = [];
      result.map((e) {
        items.add(Restaurant.fromJson(e as Map<String, dynamic>));
      }).toList();
      Log.d(runtimeType, 'getAllRestaurants: ${items.length}');
      return DataSuccess(items);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }

  @override
  Future<DataState<int>> saveRestaurant(Restaurant item) async {
    try {
      int result = await _databaseService.insert(_databaseService.restaurants, item.toJson());
      return DataSuccess(result);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }

  @override
  Future<DataState<int>> updateRestaurant(Restaurant item) async {
    try {
      int result = await _databaseService.update(_databaseService.restaurants, item.toJson(), where: 'id = ?', whereArgs: [item.id]);
      return DataSuccess(result);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }

  @override
  Future<DataState<int>> deleteRestaurant(int id) async {
    try {
      int result = await _databaseService.delete(_databaseService.restaurants, where: 'id = ?', whereArgs: [id]);
      return DataSuccess(result);
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      return DataFailed.unknown(message: e.toString(), s: s);
    }
  }
}
