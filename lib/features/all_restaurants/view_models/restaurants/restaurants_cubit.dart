import 'package:chromo_digital/core/enums/status.dart';
import 'package:chromo_digital/core/error/failure.dart';
import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/features/create_receipt/data/models/restaurant/restaurant.dart';
import 'package:chromo_digital/features/create_receipt/repositories/restaurant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'restaurants_state.dart';

@LazySingleton()
class RestaurantsCubit extends Cubit<RestaurantsState> {
  final RestaurantRepository _repository;

  RestaurantsCubit(this._repository) : super(RestaurantsUpdate());

  Future<void> getAllRestaurants() async {
    emit(state.copyWith(status: Status.loading));
    DataState<List<Restaurant>> result = await _repository.getAllRestaurants();
    result.when(
      success: (items) => emit(state.copyWith(items: items, status: Status.loaded)),
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error)),
    );
  }

  void saveRestaurant(Restaurant item) async {
    List<Restaurant> oldItems = [...state.items];
    emit(state.copyWith(status: Status.loading));
    DataState<int> result = await _repository.saveRestaurant(item);

    result.when(
      success: (_) => emit(state.copyWith(items: [item, ...oldItems], status: Status.loaded)),
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error)),
    );
  }

  Future<void> updateRestaurant(Restaurant item) async {
    List<Restaurant> oldItems = [...state.items];
    emit(state.copyWith(status: Status.loading));
    DataState<int> result = await _repository.updateRestaurant(item);
    result.when(
      success: (int value) {
        List<Restaurant> newItems = oldItems.map((e) => e.id == item.id ? item : e).toList();
        emit(state.copyWith(items: newItems, status: Status.loaded));
      },
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error)),
    );
  }

  void deleteRestaurant(int id) async {
    DataState<int> result = await _repository.deleteRestaurant(id);
    result.when(
      success: (int value) {
        if (value > 0) {
          List<Restaurant> newItems = state.items.where((element) => element.id != id).toList();
          emit(state.copyWith(items: newItems, status: Status.loaded));
        } else {
          emit(state.copyWith(items: state.items, status: Status.loaded));
        }
      },
      onError: (Failure failure) => emit(state.copyWith(message: failure.message, status: Status.error)),
    );
  }
}
