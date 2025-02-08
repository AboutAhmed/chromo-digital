part of 'receipt_generator_cubit.dart';

@immutable
sealed class ReceiptGeneratorState {}

final class ReceiptGeneratorInitial extends ReceiptGeneratorState {}

final class ReceiptGenerating extends ReceiptGeneratorState {}

final class ReceiptGenerated extends ReceiptGeneratorState {
  final File file;
  final ReceiptData data;

  ReceiptGenerated(this.file, this.data);
}

final class ReceiptGeneratorError extends ReceiptGeneratorState {
  final String message;

  ReceiptGeneratorError(this.message);
}
