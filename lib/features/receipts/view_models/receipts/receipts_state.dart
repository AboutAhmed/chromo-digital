part of 'receipts_cubit.dart';

@immutable
sealed class ReceiptsState {}

final class ReceiptsInitial extends ReceiptsState {}

final class ReceiptsLoading extends ReceiptsState {}

final class ReceiptsLoaded extends ReceiptsState {
  final List<Receipt> items;

  ReceiptsLoaded(this.items);
}

final class ReceiptsError extends ReceiptsState {
  final String message;

  ReceiptsError(this.message);
}
