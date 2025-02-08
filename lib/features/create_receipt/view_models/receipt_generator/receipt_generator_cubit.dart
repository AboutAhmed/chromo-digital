import 'dart:io';

import 'package:chromo_digital/core/receipt_generator/receipt_generator.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:chromo_digital/features/company/data/models/company.dart';
import 'package:chromo_digital/features/create_receipt/data/models/receipt_data/receipt_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'receipt_generator_state.dart';

@Injectable()
class ReceiptGeneratorCubit extends Cubit<ReceiptGeneratorState> {
  final ReceiptGenerator _receiptGenerator;

  ReceiptGeneratorCubit(this._receiptGenerator) : super(ReceiptGeneratorInitial());

  void generateReceipt(BuildContext context, final ReceiptData data, final Company? company, {final String restaurantBillImagePath = ''}) async {
    try {
      emit(ReceiptGenerating());

      final String? path = await _receiptGenerator.getDirectory();
      final String fileName = 'receipt_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final File file = await _receiptGenerator.generate(
        context: context..mounted,
        item: data,
        path: path!,
        fileName: fileName,
        company: company,
        restaurantBillImagePath: restaurantBillImagePath,
      );
      emit(ReceiptGenerated(file, data));
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
      emit(ReceiptGeneratorError(e.toString()));
    }
  }
}
