part of 'restaurants_cubit.dart';

@immutable
sealed class RestaurantsState {
  final List<Restaurant> items;
  final Status status;
  final String? message;

  const RestaurantsState({
    this.items = const [],
    this.status = Status.initial,
    this.message,
  });

  RestaurantsState copyWith({
    List<Restaurant>? items,
    Status? status,
    String? message,
  });
}

final class RestaurantsUpdate extends RestaurantsState {
  const RestaurantsUpdate({
    super.items = const [],
    super.status = Status.initial,
    super.message,
  });

  @override
  RestaurantsState copyWith({
    List<Restaurant>? items,
    Status? status,
    String? message,
  }) {
    return RestaurantsUpdate(
      items: items ?? this.items,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
