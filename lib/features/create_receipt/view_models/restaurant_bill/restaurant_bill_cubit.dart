// import 'package:chromo_digital/core/error/failure.dart';
// import 'package:chromo_digital/core/resources/data_state.dart';
// import 'package:chromo_digital/features/create_receipt/data/models/restaurant_bill/restaurant_bill.dart';
// import 'package:chromo_digital/features/create_receipt/repositories/restaurant_bill_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';
//
// part 'restaurant_bill_state.dart';
//
// @Injectable()
// class RestaurantBillCubit extends Cubit<RestaurantBillState> {
//   final RestaurantBillRepository _repository;
//
//   RestaurantBillCubit(this._repository) : super(RestaurantBillInitial());
//
//   Future<void> getAllRestaurantBill() async {
//     DataState<List<RestaurantBill>> result = await _repository.getAllRestaurantBill();
//     result.when(
//       success: (items) => emit(RestaurantBillLoaded(items)),
//       onError: (Failure failure) => emit(RestaurantBillError(failure.message)),
//     );
//   }
//
//   void saveRestaurantBill(RestaurantBill item) async {
//     DataState<int> result = await _repository.saveRestaurantBill(item);
//     result.when(
//       success: (int value) {
//         if (value > 0) {
//           if (state is RestaurantBillLoaded) {
//             emit(RestaurantBillLoaded((state as RestaurantBillLoaded).items..add(item.copyWith(id: value))));
//           } else {
//             emit(RestaurantBillLoaded([item.copyWith(id: value)]));
//           }
//         }
//       },
//       onError: (Failure failure) => emit(RestaurantBillError(failure.message)),
//     );
//   }
// }
