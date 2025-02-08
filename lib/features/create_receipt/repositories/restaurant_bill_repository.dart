// import 'package:chromo_digital/core/resources/data_state.dart';
// import 'package:chromo_digital/core/services/logger/logger.dart';
// import 'package:chromo_digital/core/services/storage/database/app_database_service.dart';
// import 'package:chromo_digital/features/create_receipt/data/models/restaurant_bill/restaurant_bill.dart';
// import 'package:injectable/injectable.dart';
//
// abstract class RestaurantBillRepository {
//   Future<DataState<List<RestaurantBill>>> getAllRestaurantBill();
//
//   Future<DataState<int>> saveRestaurantBill(RestaurantBill item);
// }
//
// @LazySingleton(as: RestaurantBillRepository)
// class RestaurantBillRepositoryImpl implements RestaurantBillRepository {
//   final AppDatabaseService _databaseService;
//
//   RestaurantBillRepositoryImpl(this._databaseService);
//
//   @override
//   Future<DataState<List<RestaurantBill>>> getAllRestaurantBill() async {
//     try {
//       String query = 'Select * from ${_databaseService.restaurantBill}';
//       List<Map<String, Object?>> result = await _databaseService.read(query);
//       List<RestaurantBill> items = [];
//       result.map((e) {
//         items.add(RestaurantBill.fromJson(e as Map<String, dynamic>));
//       });
//       return DataSuccess(items);
//     } catch (e, s) {
//       Log.e(runtimeType, e.toString(), s);
//       return DataFailed.unknown(message: e.toString(), s: s);
//     }
//   }
//
//   @override
//   Future<DataState<int>> saveRestaurantBill(RestaurantBill item) async {
//     try {
//       int result = await _databaseService.insert(_databaseService.restaurantBill, item.toMap());
//       return DataSuccess(result);
//     } catch (e, s) {
//       Log.e(runtimeType, e.toString(), s);
//       return DataFailed.unknown(message: e.toString(), s: s);
//     }
//   }
// }
