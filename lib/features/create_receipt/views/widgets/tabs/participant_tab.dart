import 'package:chromo_digital/core/bloc/helper.dart';
import 'package:chromo_digital/core/card/my_card.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/extensions/build_context_extension.dart';
import 'package:chromo_digital/core/mixin/validator.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:chromo_digital/core/widgets/fields/app_text_form_field.dart';
import 'package:chromo_digital/features/all_participants/view_models/participants/participants_cubit.dart';
import 'package:chromo_digital/features/create_receipt/data/models/Participant/participants.dart';
import 'package:chromo_digital/features/create_receipt/view_models/receipt/receipt_cubit.dart';
import 'package:chromo_digital/features/create_receipt/view_models/receipt/receipt_state.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ParticipantTab extends StatefulWidget {
  final PageController controller;

  const ParticipantTab({
    super.key,
    required this.controller,
  });

  @override
  State<ParticipantTab> createState() => _ParticipantTabState();
}

class _ParticipantTabState extends State<ParticipantTab> with Validator {
  final _saveDataHandler = Handler<bool>(false);
  final _formStateHandler = Handler<AutovalidateMode>(AutovalidateMode.disabled);

  final _participantNameController = TextEditingController();

  final ParticipantsCubit _participantsCubit = sl<ParticipantsCubit>();
  final ReceiptCubit _receiptCubit = sl<ReceiptCubit>();

  @override
  void initState() {
    super.initState();
    _participantsCubit.getAllParticipants();
  }

  @override
  void dispose() {
    super.dispose();
    _participantNameController.dispose();
    _formStateHandler.close();
    _saveDataHandler.close();
  }

  void _animateToNextPage() {
    widget.controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ReceiptCubit, ReceiptState, List<FormData<Participant>>>(
      bloc: _receiptCubit,
      selector: (state) => state.participants,
      builder: (context, selectedItems) {
        return Column(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 16.0,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<ParticipantsCubit, ParticipantsState>(
                    bloc: _participantsCubit,
                    builder: (context, state) {
                      List<Participant> items = [...state.items];

                      return items.isEmpty
                          ? const SizedBox.shrink()
                          : Column(
                              spacing: 16.0,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextFormField.multiSelectionDropdown(
                                  key: ValueKey(selectedItems),
                                  selectedItems:
                                      selectedItems.map((item) => DropdownData<Participant>(value: item.data!, label: item.data!.name)).toList(),
                                  title: AppStrings.chooseParticipants,
                                  hintText: AppStrings.select,
                                  onChanged: (values) {
                                    List<FormData<Participant>> items = values.map((e) => FormData.db(data: e)).toList();
                                    _receiptCubit.onParticipantsAdd(items);
                                  },
                                  items: items.map((item) => DropdownData<Participant>(value: item, label: item.name)).toList(),
                                ),
                                const SizedBox.shrink(),
                              ],
                            );
                    },
                  ),
                  ValueListenableBuilder(
                      valueListenable: _participantNameController,
                      builder: (context, value, child) {
                        return AppTextFormField(
                          controller: _participantNameController,
                          title: AppStrings.addNewParticipantNameAndCompany,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.none,
                          textCapitalization: TextCapitalization.words,
                          suffixIcon: value.text.isNotEmpty
                              ? MyCard.outline(
                                  onTap: () {
                                    Participant item = Participant(name: _participantNameController.text);
                                    _receiptCubit.onParticipantsAdd([FormData.newEntry(data: item)]);
                                    _participantNameController.clear();
                                  },
                                  height: 33.0,
                                  width: 33.0,
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: context.primary.withAlpha(100),
                                  child: Icon(LucideIcons.plus, color: context.onPrimary),
                                ).center().square(36.0)
                              : null,
                        );
                      }),
                  if (selectedItems.isNotEmpty)
                    ...selectedItems.map((e) {
                      return MyCard.outline(
                        child: ListTile(
                          title: RichText(
                            text: TextSpan(
                              text: e.data!.name,
                              style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                              children: [
                                TextSpan(text: ' '),
                                if (e.type == EntryType.newEntry)
                                  TextSpan(
                                    text: AppStrings.new_,
                                    style: context.bodySmall!.copyWith(color: context.secondary).small,
                                  )
                                else if (e.type == EntryType.saved)
                                  TextSpan(
                                    text: AppStrings.saved,
                                    style: context.bodySmall!.copyWith(color: context.secondary).small,
                                  )
                              ],
                            ),
                          ),
                          trailing: MyCard.outline(
                            onTap: () => _receiptCubit.onParticipantsRemove(e),
                            height: 28.0,
                            width: 28.0,
                            borderRadius: BorderRadius.circular(50.0),
                            color: context.errorContainer.withAlpha(100),
                            child: Icon(LucideIcons.x, color: context.errorContainer, size: 18.0),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ).expanded(),
            Column(
              children: [
                BlocBuilder<Handler<bool>, bool>(
                  bloc: _saveDataHandler,
                  builder: (context, save) {
                    return CheckboxListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(AppStrings.saveNewParticipant, style: context.titleSmall),
                      value: save,
                      onChanged: (value) => _saveDataHandler.update(value ?? false),
                    );
                  },
                ),
                AppButton(
                  onPressed: _onNextPressed,
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

  void _onNextPressed() async {
    if (_receiptCubit.state.participants.isEmpty) {
      context.showToast(AppStrings.pleaseSelectAtLeastOneParticipant);
      return;
    } else {
      _saveParticipant();
    }
  }

  void _saveParticipant() {
    List<FormData<Participant>> items = _receiptCubit.state.participants;
    List<Participant> tobeSaved = [];
    if (_saveDataHandler.state) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].type == EntryType.newEntry) {
          tobeSaved.add(items[i].data!);
          items[i] = FormData.saved(data: items[i].data!);
        }
      }

      _receiptCubit.onParticipantsChanged(items);
      _participantsCubit.saveAParticipants(tobeSaved);
    }
    _participantNameController.clear();
    _animateToNextPage();
  }
}
