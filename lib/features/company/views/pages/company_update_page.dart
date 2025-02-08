import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/config/routes/routes.gr.dart';
import 'package:chromo_digital/core/bloc/helper.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/extensions/build_context_extension.dart';
import 'package:chromo_digital/core/mixin/validator.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:chromo_digital/core/widgets/fields/app_text_form_field.dart';
import 'package:chromo_digital/features/company/data/models/company.dart';
import 'package:chromo_digital/features/company/view_models/company/company_cubit.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class CompanyUpdatePage extends StatefulWidget {
  final Company? item;

  const CompanyUpdatePage({super.key, this.item});

  @override
  State<CompanyUpdatePage> createState() => _CompanyUpdatePageState();
}

class _CompanyUpdatePageState extends State<CompanyUpdatePage> with Validator {
  final Handler<AutovalidateMode> _autovalidateModeHandler = Handler<AutovalidateMode>(AutovalidateMode.disabled);
  final CompanyCubit _companyCubit = sl<CompanyCubit>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postIdController = TextEditingController();
  final _houseNumberController = TextEditingController();
  bool? showOnReceipt;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _streetController.text = widget.item!.street;
      _cityController.text = widget.item!.city;
      _postIdController.text = widget.item!.postId;
      _houseNumberController.text = widget.item!.houseNumber;
      showOnReceipt = widget.item!.showOnReceipt;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _postIdController.dispose();
    _houseNumberController.dispose();
    _autovalidateModeHandler.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(LucideIcons.chevronLeft), onPressed: context.maybePop)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: BlocBuilder<Handler<AutovalidateMode>, AutovalidateMode>(
          bloc: _autovalidateModeHandler,
          builder: (context, autovalidateMode) {
            return Form(
              key: _formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  if (widget.item != null) ...{
                    Text(AppStrings.updateCompanyData, style: context.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                    Text(AppStrings.youCanUpdateTheFollowingDetails, style: context.bodyMedium!),
                  } else ...{
                    Text(AppStrings.addCompanyData, style: context.titleMedium!),
                    Text(AppStrings.youCanAddTheFollowingDetails, style: context.bodyMedium!),
                  },
                  const SizedBox.shrink(),
                  AppTextFormField(
                    controller: _nameController,
                    title: AppStrings.companyName,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    validator: validateCompanyName,
                    textCapitalization: TextCapitalization.words,
                  ),
                  AppTextFormField(
                    controller: _streetController,
                    title: AppStrings.companyStreet,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: validateCompanyStreet,
                  ),
                  AppTextFormField(
                    controller: _houseNumberController,
                    title: AppStrings.companyHouseNo,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: validateCompanyHouseNumber,
                  ),
                  AppTextFormField(
                    controller: _postIdController,
                    title: AppStrings.companyPostId,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: validateCompanyPostId,
                  ),
                  AppTextFormField(
                    controller: _cityController,
                    title: AppStrings.companyCity,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: validateCompanyCity,
                  ),
                  CheckboxListTile(
                    title: Text(AppStrings.showDetailsOnReceipt, style: context.titleSmall),
                    value: showOnReceipt,
                    onChanged: (value) {
                      setState(() {
                        showOnReceipt = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 6.0),
                  BlocConsumer<CompanyCubit, CompanyState>(
                    bloc: _companyCubit,
                    listener: (context, state) {
                      if (state is CompanyLoaded) {
                        context.showToast(AppStrings.companyDataSavedSuccessfully);
                        if (widget.item == null) {
                          context.pushRoute(HomeRoute());
                        } else {
                          context.maybePop();
                        }
                      } else if (state is CompanyError) {
                        context.showToast(state.message);
                      }
                    },
                    builder: (context, state) {
                      return AppButton(
                        isProcessing: state is CompanyLoading,
                        onPressed: _attemptToHandleData,
                        child: Text(widget.item != null ? AppStrings.update : AppStrings.save),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _attemptToHandleData() {
    context.unfocus();
    if (!_formKey.currentState!.validate()) {
      _autovalidateModeHandler.update(AutovalidateMode.always);
      return;
    }

    final item = Company(
      id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text,
      street: _streetController.text,
      houseNumber: _houseNumberController.text,
      postId: _postIdController.text,
      city: _cityController.text,
      createdAt: DateTime.now(),
      showOnReceipt: showOnReceipt ?? false,
    );
    if (widget.item != null) {
      _companyCubit.updateCompany(item);
    } else {
      _companyCubit.saveCompany(item);
    }
  }
}
