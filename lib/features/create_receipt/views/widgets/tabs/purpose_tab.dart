import 'package:chromo_digital/core/bloc/helper.dart';
import 'package:chromo_digital/core/card/my_card.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/extensions/build_context_extension.dart';
import 'package:chromo_digital/core/mixin/validator.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:chromo_digital/core/widgets/fields/app_text_form_field.dart';
import 'package:chromo_digital/features/all_purposes/view_models/purposes/purposes_cubit.dart';
import 'package:chromo_digital/features/create_receipt/data/models/purpose/purpose.dart';
import 'package:chromo_digital/features/create_receipt/view_models/receipt/receipt_cubit.dart';
import 'package:chromo_digital/features/create_receipt/view_models/receipt/receipt_state.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PurposeTab extends StatefulWidget {
  final PageController controller;

  const PurposeTab({
    super.key,
    required this.controller,
  });

  @override
  State<PurposeTab> createState() => _PurposeTabState();
}

class _PurposeTabState extends State<PurposeTab> with Validator {
  final _saveDataHandler = Handler<bool>(false);
  final _textEditingController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();

  final PurposesCubit purposesCubit = sl<PurposesCubit>();
  final ReceiptCubit _receiptCubit = sl<ReceiptCubit>();

  @override
  void initState() {
    super.initState();
    purposesCubit.getAllPurposes();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _addressController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
    _saveDataHandler.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ReceiptCubit, ReceiptState, FormData<Purpose>?>(
      bloc: _receiptCubit,
      selector: (state) => state.purpose,
      builder: (context, selectedItem) {
        return Column(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                spacing: 16.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<PurposesCubit, PurposesState>(
                    bloc: purposesCubit,
                    builder: (context, state) {
                      List<Purpose> items = [...state.items];

                      return items.isEmpty
                          ? const SizedBox.shrink()
                          : Column(
                              spacing: 16.0,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.chooseAPurpose, style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
                                AppTextFormField.dropdown(
                                  key: ValueKey(selectedItem),
                                  title: AppStrings.chooseAPurpose,
                                  hintText: AppStrings.select,
                                  onChanged: (item) => _receiptCubit.onPurposeChanged(FormData.db(data: item)),
                                  items: items.map((item) => DropdownData<Purpose>(value: item, label: item.value)).toList(),
                                ),
                                const SizedBox.shrink(),
                              ],
                            );
                    },
                  ),
                  if (selectedItem?.data != null && selectedItem?.type == EntryType.dbEntry)
                    MyCard.outline(
                      child: ListTile(
                        title: Text(selectedItem!.data!.value, style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
                        trailing: MyCard.outline(
                          onTap: () => _receiptCubit.onPurposeChanged(FormData.empty()),
                          height: 28.0,
                          width: 28.0,
                          borderRadius: BorderRadius.circular(50.0),
                          color: context.errorContainer.withAlpha(100),
                          child: Icon(LucideIcons.x, color: context.errorContainer, size: 18.0),
                        ),
                      ),
                    )
                  else
                    AppTextFormField(
                      controller: _textEditingController,
                      title: AppStrings.purpose,
                      validator: validateName,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                    ),
                ],
              ),
            ).expanded(),
            Column(
              mainAxisSize: MainAxisSize.max,
              spacing: 8.0,
              children: [
                if (selectedItem == null || (selectedItem.type != EntryType.dbEntry && selectedItem.type != EntryType.saved))
                  BlocBuilder<Handler<bool>, bool>(
                    bloc: _saveDataHandler,
                    builder: (context, save) {
                      return CheckboxListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(AppStrings.saveNewPurpose, style: context.titleSmall),
                        value: save,
                        onChanged: (value) => _saveDataHandler.update(value ?? false),
                      );
                    },
                  ),
                AppButton(
                  onPressed: _attemptToSubmit,
                  child: Text(AppStrings.next),
                ),
                SizedBox(height: context.paddingBottom + 12.0),
              ],
            ).paddingSymmetric(horizontal: 16.0),
          ],
        );
      },
    );
  }

  void _attemptToSubmit() {
    FormData<Purpose>? item = _receiptCubit.state.purpose;
    if (item == null && _textEditingController.text.isEmpty) {
      context.showToast(AppStrings.pleaseAddAPurpose);
    } else if (item != null && (item.type == EntryType.dbEntry || item.type == EntryType.saved)) {
      _animateToNextPage();
    } else {
      _savePurpose();
    }
  }

  _savePurpose() {
    FormData<Purpose> item = FormData.newEntry(data: Purpose(value: _textEditingController.text));

    if (_saveDataHandler.state) {
      purposesCubit.savePurpose(item.data!);
      item = item.copyWith(type: EntryType.saved);
    }
    _receiptCubit.onPurposeChanged(item);
    _animateToNextPage();
  }

  void _animateToNextPage() => widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
}
