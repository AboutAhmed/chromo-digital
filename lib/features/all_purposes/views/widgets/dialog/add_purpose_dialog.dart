import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/mixin/validator.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:chromo_digital/core/widgets/fields/app_text_form_field.dart';
import 'package:chromo_digital/features/create_receipt/data/models/purpose/purpose.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';

class AddPurposeDialog extends StatelessWidget with Validator {
  final Purpose? item;

  AddPurposeDialog({super.key, this.item});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String name = '';
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.0,
        children: [
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: AppTextFormField(
              initialValue: item?.value,
              title: AppStrings.name,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onChanged: (text) => name = text,
              validator: (value) => validateAsRequired(AppStrings.purpose, value: value),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            spacing: 12,
            children: [
              AppButton.outline(
                onPressed: context.maybePop,
                child: Text(AppStrings.cancel),
              ).expanded(),
              AppButton(
                onPressed: () => _attemptToSave(context, name),
                child: Text(AppStrings.update),
              ).expanded(),
            ],
          ),
        ],
      ),
    );
  }

  void _attemptToSave(BuildContext context, String? value) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    if (item != null) {
      Purpose updatedItem = item!.copyWith(value: value);
      context.maybePop(updatedItem);
    } else {
      Purpose newItem = Purpose(value: value!);
      context.maybePop(newItem);
    }
  }
}
