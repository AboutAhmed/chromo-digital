import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/mixin/validator.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:chromo_digital/core/widgets/fields/app_text_form_field.dart';
import 'package:chromo_digital/features/create_receipt/data/models/Participant/participants.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';

class AddParticipantDialog extends StatelessWidget with Validator {
  final Participant? item;

  AddParticipantDialog({super.key, this.item});

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
              initialValue: item?.name,
              title: AppStrings.name,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onChanged: (value) => name = value,
              validator: (value) => validateAsRequired(AppStrings.participant, value: value),
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

  void _attemptToSave(BuildContext context, String? name) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    if (item != null) {
      Participant updatedItem = item!.copyWith(name: name);
      context.maybePop(updatedItem);
    } else {
      Participant newParticipant = Participant(name: name!);
      context.maybePop(newParticipant);
    }
  }
}
