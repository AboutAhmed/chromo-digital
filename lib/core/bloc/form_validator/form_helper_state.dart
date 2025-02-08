part of 'form_helper.dart';

@immutable
abstract class FormHelperState {
  final AutovalidateMode autovalidateMode;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final GlobalKey<FormState> formKey;

  const FormHelperState({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.confirmPassword,
    this.autovalidateMode = AutovalidateMode.disabled,
    required this.formKey,
  });

  FormHelperState copyWith({
    final String? firstName,
    final String? lastName,
    final String? email,
    final String? password,
    final String? confirmPassword,
    final AutovalidateMode? autovalidateMode,
  });
}

class FormHelperUpdate extends FormHelperState {
  const FormHelperUpdate({
    super.firstName,
    super.lastName,
    super.email,
    super.password,
    super.confirmPassword,
    super.autovalidateMode = AutovalidateMode.disabled,
    required super.formKey,
  });

  @override
  FormHelperState copyWith({
    final String? firstName,
    final String? lastName,
    final String? email,
    final String? password,
    final String? confirmPassword,
    final AutovalidateMode? autovalidateMode,
  }) {
    return FormHelperUpdate(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      autovalidateMode: autovalidateMode ?? this.autovalidateMode,
      formKey: formKey,
    );
  }
}
