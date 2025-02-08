import 'package:chromo_digital/core/bloc/helper.dart';
import 'package:chromo_digital/core/card/my_card.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/mixin/validator.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:chromo_digital/core/widgets/fields/app_text_form_field.dart';
import 'package:chromo_digital/features/all_restaurants/view_models/restaurants/restaurants_cubit.dart';
import 'package:chromo_digital/features/create_receipt/data/models/restaurant/restaurant.dart';
import 'package:chromo_digital/features/create_receipt/view_models/receipt/receipt_cubit.dart';
import 'package:chromo_digital/features/create_receipt/view_models/receipt/receipt_state.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RestaurantTab extends StatefulWidget {
  final PageController controller;

  const RestaurantTab({
    super.key,
    required this.controller,
  });

  @override
  State<RestaurantTab> createState() => _RestaurantTabState();
}

class _RestaurantTabState extends State<RestaurantTab> with Validator {
  bool _isFirstClick = true;
  bool _showWarning = false;
  final _saveDataHandler = Handler<bool>(false);
  final _formStateHandler = Handler<AutovalidateMode>(AutovalidateMode.disabled);
  final _formKey = GlobalKey<FormState>();
  Restaurant? selectedRestaurant;
  final _restaurantNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();

  final RestaurantsCubit _restaurantsCubit = sl<RestaurantsCubit>();
  final ReceiptCubit _receiptCubit = sl<ReceiptCubit>();

  @override
  void initState() {
    super.initState();
    _restaurantsCubit.getAllRestaurants();
  }

  @override
  void dispose() {
    super.dispose();
    _restaurantNameController.dispose();
    _addressController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
    _formStateHandler.close();
    _saveDataHandler.close();
  }

  void _saveRestaurant() async {
    FormData<Restaurant>? item = FormData<Restaurant>(
      data: Restaurant(
        name: _restaurantNameController.text,
        address: _addressController.text,
        zipCode: int.tryParse(_zipCodeController.text) ?? -1,
        city: _cityController.text,
      ),
      type: EntryType.newEntry,
    );

    if (_saveDataHandler.state) {
      _restaurantsCubit.saveRestaurant(item.data!);
      item = item.copyWith(type: EntryType.saved);
    }
    _receiptCubit.onRestaurantChanged(item);
    _animateToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ReceiptCubit, ReceiptState, FormData<Restaurant>?>(
      bloc: _receiptCubit,
      selector: (state) => state.restaurant,
      builder: (context, selectedItem) {
        return Column(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<RestaurantsCubit, RestaurantsState>(
                    bloc: _restaurantsCubit,
                    builder: (context, state) {
                      List<Restaurant> items = [...state.items];
                      return items.isEmpty
                          ? const SizedBox.shrink()
                          : Column(
                              spacing: 16.0,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.chooseARestaurant, style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
                                AppTextFormField.dropdown(
                                  key: ValueKey(selectedItem),
                                  title: AppStrings.chooseARestaurant,
                                  hintText: AppStrings.select,
                                  onChanged: (item) => _receiptCubit.onRestaurantChanged(FormData.db(data: item)),
                                  items: items.map((item) => DropdownData<Restaurant>(value: item, label: item.name)).toList(),
                                ),
                                const SizedBox.shrink(),
                              ],
                            );
                    },
                  ),
                  if (selectedItem?.data != null && selectedItem?.type == EntryType.dbEntry)
                    MyCard.outline(
                      child: ListTile(
                        title: Text(selectedItem!.data!.name, style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text(selectedItem.data!.address, style: context.bodySmall!.copyWith(fontWeight: FontWeight.w600).small),
                        trailing: MyCard.outline(
                          onTap: () => _receiptCubit.onRestaurantChanged(FormData.empty()),
                          height: 28.0,
                          width: 28.0,
                          borderRadius: BorderRadius.circular(50.0),
                          color: context.errorContainer.withAlpha(100),
                          child: Icon(LucideIcons.x, color: context.errorContainer, size: 18.0),
                        ),
                      ),
                    )
                  else
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
                                controller: _restaurantNameController,
                                title: AppStrings.restaurantName,
                                validator: validateName,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                              ),
                              AppTextFormField(
                                controller: _addressController,
                                title: AppStrings.address,
                                validator: validateAddress,
                                keyboardType: TextInputType.streetAddress,
                                inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                              ),
                              AppTextFormField(
                                controller: _zipCodeController,
                                title: AppStrings.zipCode,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: validateZipCode,
                                textInputAction: TextInputAction.next,
                              ),
                              AppTextFormField(
                                controller: _cityController,
                                title: AppStrings.city,
                                validator: validateCity,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.done,
                              ),
                            ],
                          ),
                        );
                      },
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
                        title: Text(AppStrings.saveRestaurant, style: context.titleSmall),
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

//   void _attemptToSubmit() {
//     FormData<Restaurant>? item = _receiptCubit.state.restaurant;
//     if (item == null) {
//       _formStateHandler.update(AutovalidateMode.always);
//       if (_formKey.currentState!.validate()) {
//         _saveRestaurant();
//       }
//     } else {
//       _animateToNextPage();
//     }
//   }
//
//   void _animateToNextPage() => widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
// }

  void _attemptToSubmit() {
    FormData<Restaurant>? item = _receiptCubit.state.restaurant;
    if (item == null && _isFirstClick) {
      _formStateHandler.update(AutovalidateMode.always);
      if (_formKey.currentState!.validate()) {
        _saveRestaurant();
        _isFirstClick = false;
        _showWarning = false;
      } else if (!_showWarning) {
        _showWarningDialog();
        _isFirstClick = false;
        _showWarning = true;
      }
    } else {
      _formStateHandler.update(AutovalidateMode.disabled);
      _animateToNextPage();
    }
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppStrings.warningTitle),
          content: Text(AppStrings.youShouldNotLeaveThisEmpty),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppStrings.ok)),
          ],
        );
      },
    );
  }

  void _animateToNextPage() {
    widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }
}
