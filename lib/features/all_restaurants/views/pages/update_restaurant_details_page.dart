import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/core/bloc/helper.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/enums/status.dart';
import 'package:chromo_digital/core/extensions/build_context_extension.dart';
import 'package:chromo_digital/core/mixin/validator.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:chromo_digital/core/widgets/fields/app_text_form_field.dart';
import 'package:chromo_digital/features/all_restaurants/view_models/restaurants/restaurants_cubit.dart';
import 'package:chromo_digital/features/create_receipt/data/models/restaurant/restaurant.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class UpdateRestaurantDetailsPage extends StatefulWidget {
  final Restaurant? item;

  const UpdateRestaurantDetailsPage({super.key, this.item});

  @override
  State<UpdateRestaurantDetailsPage> createState() => _UpdateRestaurantDetailsPageState();
}

class _UpdateRestaurantDetailsPageState extends State<UpdateRestaurantDetailsPage> with Validator {
  final _restaurantNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Handler<AutovalidateMode> _autovalidateModeHandler = Handler<AutovalidateMode>(AutovalidateMode.disabled);
  final RestaurantsCubit _restaurantsCubit = sl<RestaurantsCubit>();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _restaurantNameController.text = widget.item!.name;
      _addressController.text = widget.item!.address;
      _zipCodeController.text = widget.item!.zipCode.toString();
      _cityController.text = widget.item!.city;
    }
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _addressController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
    _autovalidateModeHandler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<Handler<AutovalidateMode>, AutovalidateMode>(
          bloc: _autovalidateModeHandler,
          builder: (context, autovalidateMode) {
            return Form(
              key: _formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item != null ? AppStrings.updateRestaurantDetails : AppStrings.addANewRestaurant,
                    style: context.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  AppTextFormField(
                    validator: validateName,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    controller: _restaurantNameController,
                    title: AppStrings.restaurantName,
                    keyboardType: TextInputType.name,
                  ),
                  AppTextFormField(
                    validator: validateAddress,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    controller: _addressController,
                    title: AppStrings.address,
                    keyboardType: TextInputType.text,
                  ),
                  AppTextFormField(
                    validator: validateZipCode,
                    textInputAction: TextInputAction.next,
                    controller: _zipCodeController,
                    title: AppStrings.zipCode,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                  AppTextFormField(
                    validator: validateCity,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.words,
                    controller: _cityController,
                    title: AppStrings.city,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 12.0),
                  BlocConsumer<RestaurantsCubit, RestaurantsState>(
                      bloc: _restaurantsCubit,
                      listener: (BuildContext context, state) {
                        if (state.status == Status.loaded) {
                          context.maybePop();
                          if (widget.item != null) {
                            context.showToast(AppStrings.restaurantDataUpdateSuccessfully);
                          } else {
                            context.showToast(AppStrings.restaurantDataSavedSuccessfully);
                          }
                        } else if (state.status == Status.error) {
                          context.showToast(state.message ?? AppStrings.somethingWentWrong);
                        }
                      },
                      builder: (context, state) {
                        return AppButton(
                          isProcessing: state.status == Status.loading,
                          onPressed: _attemptToSave,
                          child: Text(widget.item != null ? AppStrings.update : AppStrings.save),
                        );
                      }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _attemptToSave() {
    if (!_formKey.currentState!.validate()) {
      _autovalidateModeHandler.update(AutovalidateMode.always);
      return;
    }
    final restaurant = Restaurant(
      name: _restaurantNameController.text,
      address: _addressController.text,
      zipCode: int.parse(_zipCodeController.text),
      city: _cityController.text,
    );
    if (widget.item != null) {
      _restaurantsCubit.updateRestaurant(restaurant.copyWith(id: widget.item!.id));
    } else {
      _restaurantsCubit.saveRestaurant(restaurant);
    }
  }
}
