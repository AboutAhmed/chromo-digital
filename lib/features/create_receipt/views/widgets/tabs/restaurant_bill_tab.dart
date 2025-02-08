import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/config/routes/routes.gr.dart';
import 'package:chromo_digital/core/bloc/helper.dart';
import 'package:chromo_digital/core/card/my_card.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/extensions/build_context_extension.dart';
import 'package:chromo_digital/core/mixin/formatter.dart';
import 'package:chromo_digital/core/mixin/validator.dart';
import 'package:chromo_digital/core/packages/image_picker/image_picker.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:chromo_digital/core/widgets/app_image.dart';
import 'package:chromo_digital/core/widgets/fields/app_text_form_field.dart';
import 'package:chromo_digital/features/company/data/models/company.dart';
import 'package:chromo_digital/features/company/view_models/company/company_cubit.dart';
import 'package:chromo_digital/features/create_receipt/data/models/receipt/receipt.dart';
import 'package:chromo_digital/features/create_receipt/data/models/receipt_data/receipt_data.dart';
import 'package:chromo_digital/features/create_receipt/view_models/receipt/receipt_cubit.dart';
import 'package:chromo_digital/features/create_receipt/view_models/receipt/receipt_state.dart';
import 'package:chromo_digital/features/create_receipt/view_models/receipt_generator/receipt_generator_cubit.dart';
import 'package:chromo_digital/features/create_receipt/views/widgets/signature_pad.dart';
import 'package:chromo_digital/features/receipts/view_models/receipts/receipts_cubit.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RestaurantBillTab extends StatefulWidget {
  final PageController controller;

  const RestaurantBillTab({
    super.key,
    required this.controller,
  });

  @override
  State<RestaurantBillTab> createState() => _RestaurantBillTabState();
}

class _RestaurantBillTabState extends State<RestaurantBillTab> with Validator, Formatter {
  final _addTipHandler = Handler<bool>(false);
  final Handler<List<File>> _imageHandler = Handler([]);
  final Handler<AutovalidateMode> _formStateHandler = Handler(AutovalidateMode.disabled);
  final _formKey = GlobalKey<FormState>();
  final ReceiptCubit _receiptCubit = sl<ReceiptCubit>();
  final _notesController = TextEditingController();
  final _amountController = TextEditingController();
  final _tipController = TextEditingController();
  final ReceiptGeneratorCubit _receiptGeneratorCubit = sl<ReceiptGeneratorCubit>();

  @override
  void initState() {
    super.initState();
    _receiptCubit.addVisitDate(DateTime.now());
  }

  @override
  void dispose() {
    _notesController.dispose();
    _amountController.dispose();
    _tipController.dispose();
    _imageHandler.close();
    _formStateHandler.close();
    _addTipHandler.close();
    _receiptGeneratorCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptCubit, ReceiptState>(
      bloc: _receiptCubit,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.uploadRestaurantBillOptional, style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
              BlocBuilder<Handler<List<File>>, List<File>>(
                bloc: _imageHandler,
                builder: (context, images) {
                  return Wrap(
                    spacing: 12.0,
                    children: [
                      MyCard.outline(
                        color: context.cardColor,
                        onTap: () => openPhotoPicker(
                          context,
                          maxImagesLimit: 1,
                          initialValue: [...images],
                          onResult: (files) {
                            _imageHandler.update([...files]);
                          },
                        ),
                        width: 100.0,
                        height: 100.0,
                        child: Icon(LucideIcons.camera),
                      ),
                      ...images.map(
                        (file) => _ImageCard(
                          file: file,
                          onDelete: (file) {
                            List<File> updatedFiles = [...images]..remove(file);
                            _imageHandler.update(updatedFiles);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              BlocBuilder<Handler<AutovalidateMode>, AutovalidateMode>(
                  bloc: _formStateHandler,
                  builder: (context, autovalidateMode) {
                    return Form(
                      key: _formKey,
                      autovalidateMode: autovalidateMode,
                      child: Column(
                        spacing: 16.0,
                        children: [
                          AppTextFormField(
                            controller: _notesController,
                            title: AppStrings.notes,
                            hintText: AppStrings.addNotesHere,
                            onChanged: _receiptCubit.addNotes,
                            inputFormatters: [LengthLimitingTextInputFormatter(360)],
                          ),
                          AppTextFormField.date(
                            initialValue: state.visitDate,
                            title: AppStrings.visitedDate,
                            hintText: AppStrings.chooseDate,
                            lastDate: DateTime.now(),
                            onChanged: _receiptCubit.addVisitDate,
                            validator: validateVisitDate,
                          ),
                          AppTextFormField(
                            controller: _amountController,
                            title: AppStrings.amountOfRestaurantBill,
                            inputFormatters: germanCurrencyFormatters,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: validateAmount,
                          ),
                          BlocBuilder<Handler<bool>, bool>(
                            bloc: _addTipHandler,
                            builder: (context, addTip) {
                              return Column(
                                children: [
                                  CheckboxListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(AppStrings.addAmountOfTip, style: context.titleSmall),
                                    value: addTip,
                                    onChanged: (value) => _addTipHandler.update(value ?? false),
                                  ),
                                  if (addTip)
                                    Column(
                                      spacing: 16.0,
                                      children: [
                                        AppTextFormField(
                                          controller: _tipController,
                                          inputFormatters: germanCurrencyFormatters,
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          validator: validateAmount,
                                        ),
                                        Column(
                                          spacing: 12.0,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(AppStrings.insertWaitersSignature, style: context.titleSmall),
                                                Text(AppStrings.optional, style: context.titleSmall),
                                              ],
                                            ),
                                            MyCard.outline(
                                              onTap: _addWaiterSignature,
                                              width: context.width,
                                              height: 230,
                                              child: _receiptCubit.state.waiterSignaturePath != null
                                                  ? AppImage.file(
                                                      file: File(state.waiterSignaturePath!),
                                                      height: 230,
                                                      fit: BoxFit.cover,
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    )
                                                  : TextButton(onPressed: _addWaiterSignature, child: Text(AppStrings.addSignature)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                ],
                              );
                            },
                          ),
                          Column(
                            spacing: 12.0,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppStrings.insertManagingDirectorsSignature),
                              MyCard.outline(
                                height: 230.0,
                                onTap: _addManagingDirectorSignature,
                                width: context.width,
                                child: _receiptCubit.state.managingDirectorSignaturePath != null
                                    ? AppImage.file(
                                        file: File(state.managingDirectorSignaturePath!),
                                        height: 230,
                                        fit: BoxFit.cover,
                                        borderRadius: BorderRadius.circular(8.0),
                                      )
                                    : TextButton(onPressed: _addManagingDirectorSignature, child: Text(AppStrings.addSignature)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox(height: 24.0),
              BlocConsumer<ReceiptGeneratorCubit, ReceiptGeneratorState>(
                bloc: _receiptGeneratorCubit,
                listener: (context, state) {
                  if (state is ReceiptGenerated) {
                    _saveAndViewReceipt(state.file, state.data);
                  } else if (state is ReceiptGeneratorError) {
                    context.showToast(state.message);
                  }
                },
                builder: (context, state) {
                  return AppButton(
                    isProcessing: state is ReceiptGenerating,
                    onPressed: _attemptToCreateReceipt,
                    child: Text(AppStrings.save),
                  );
                },
              ),
              SizedBox(height: context.paddingBottom + 12.0),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addManagingDirectorSignature() async {
    String? path = (await context.showAppGeneralDialog(title: AppStrings.addSignature, child: SignaturePad())) as String?;
    if (path != null) _receiptCubit.addManagingDirectorSignature(path);
  }

  Future<void> _addWaiterSignature() async {
    String? path = (await context.showAppGeneralDialog(title: AppStrings.addSignature, child: SignaturePad())) as String?;
    if (path != null) _receiptCubit.addWaiterSignature(path);
  }

  // Future<void> _attemptToCreateReceipt() async {
  //   if (!_formKey.currentState!.validate()) {
  //     _formStateHandler.update(AutovalidateMode.always);
  //     return;
  //   } else {
  //     _receiptCubit.addBillAmount(num.parse(_amountController.text));
  //     if (_addTipHandler.state) {
  //       _receiptCubit.addTipAmount(num.parse(_tipController.text));
  //     } else {
  //       _receiptCubit.clearWaiterSignature();
  //     }
  //     _receiptCubit.addImages(_imageHandler.state);
  //     ReceiptData receiptData = _receiptCubit.state.toReceiptData();
  //     _receiptGeneratorCubit.generateReceipt(context, receiptData);
  //   }
  // }

  Future<void> _attemptToCreateReceipt() async {
    if (!_formKey.currentState!.validate()) {
      _formStateHandler.update(AutovalidateMode.always);
      return;
    }
    try {
      // amount is in text because of the currency formatter
      // in German currency formatter, the decimal separator is a comma
      String billAmountText = _amountController.text.trim();
      String tipAmountText = _tipController.text.trim();

      _receiptCubit.addBillAmount(billAmountText);

      if (_addTipHandler.state) {
        _receiptCubit.addTipAmount(tipAmountText);
      } else {
        _receiptCubit.clearWaiterSignature();
      }

      _receiptCubit.addImages(_imageHandler.state);
      final company = sl<CompanyCubit>().state is CompanyLoaded ? (sl<CompanyCubit>().state as CompanyLoaded).item : Company.empty();

      ReceiptData receiptData = _receiptCubit.state.toReceiptData();

      _receiptGeneratorCubit.generateReceipt(context, receiptData, company, restaurantBillImagePath: _imageHandler.state.first.path);
    } catch (e) {
      Log.e("Error parsing amounts", e);
    }
  }

  void _saveAndViewReceipt(File file, ReceiptData data) {
    Receipt item = Receipt(
      id: DateTime.now().millisecondsSinceEpoch,
      name: data.restaurant.name,
      createdAt: DateTime.now(),
      filePath: file.path,
    );
    sl<ReceiptsCubit>().saveReceipt(item);
    _receiptCubit.reset();
    context.router.replace(ReceiptsRoute());
  }
}

class _ImageCard extends StatelessWidget {
  final File file;
  final ValueChanged<File> onDelete;

  const _ImageCard({
    required this.file,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        AppImage.file(file: file, width: 100.0, height: 100.0),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => onDelete(file),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 12.0,
              child: Icon(LucideIcons.trash, size: 16.0),
            ),
          ),
        )
      ],
    );
  }
}
