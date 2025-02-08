import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'form_helper_state.dart';

@Injectable()
class FormHelper extends Cubit<FormHelperState> {
  /// we're creating a form key with bloc creation
  FormHelper() : super(FormHelperUpdate(formKey: GlobalKey<FormState>()));

  void initForm({
    String firstName = '',
    String lastName = '',
    String email = '',
  }) {
    emit(state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
    ));
  }

  void onEmailChanged(String value) => emit(state.copyWith(email: value));

  void onPasswordChanged(String value) => emit(state.copyWith(password: value));

  void onConfirmPasswordChanged(String value) => emit(state.copyWith(confirmPassword: value));

  void onFirstNameChanged(String value) => emit(state.copyWith(firstName: value));

  void onLastNameChanged(String value) => emit(state.copyWith(lastName: value));

  void onAutovalidateModeChanged(AutovalidateMode value) => emit(state.copyWith(autovalidateMode: value));

  /// In case of form reset we'll reset data but form key will remain same
  void reset() => emit(FormHelperUpdate(formKey: state.formKey));
}
