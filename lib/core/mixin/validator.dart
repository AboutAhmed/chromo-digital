import 'package:chromo_digital/core/constants/app_strings.dart';

mixin Validator {
  String? validateAsRequired(String fieldName, {String? value}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${AppStrings.isRequired}';
    }
    return null;
  }

  String? validateWithRequired(String fieldName, {String? value}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${AppStrings.isRequired}';
    }
    num number = num.tryParse(value) ?? 0;
    if (number <= 0) {
      return '$fieldName ${AppStrings.mustBeGreaterThanZero}';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailIsRequired;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return AppStrings.pleaseEnterAValidEmail;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.passwordIsRequired;
    } else if (value.length < 6) {
      return AppStrings.passwordMustBeAtLeastXCharacters;
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameIsRequired;
    }
    return null;
  }

  String? validateRequiredName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameIsRequired;
    }
    return null;
  }

  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.firstNameIsRequired;
    } else if (value.length < 3) {
      return AppStrings.firstNameMustBeAtLeast3Characters;
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.lastNameIsRequired;
    } else if (value.length < 3) {
      return AppStrings.lastNameMustBeAtLeast3Characters;
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.phoneIsRequired;
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return AppStrings.pleaseEnterAValidPhoneNumber;
    }
    return null;
  }

  String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.cityIsRequired;
    } else if (value.length < 2) {
      return AppStrings.cityMustBeAtLeast2Characters;
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.addressIsRequired;
    } else if (value.length < 5) {
      return AppStrings.addressMustBeAtLeast5Characters;
    }
    return null;
  }

  String? validateRestaurantName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.restaurantNameIsRequired;
    } else if (value.length < 3) {
      return AppStrings.restaurantNameMustBeAtLeast3Characters;
    }
    return null;
  }

  String? validateZipCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.zipCodeIsRequired;
    }
    return null;
  }

  String? validateVisitDate(value) {
    if (value == null) {
      return AppStrings.visitedDateIsRequired;
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.amountIsRequired;
    }

    return null;
  }

  String? validateTip(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.tipIsRequired;
    }
    return null;
  }

  String? validateCompanyName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.companyNameIsRequired;
    }
    return null;
  }

  String? validateCompanyStreet(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.companyStreetIsRequired;
    }
    return null;
  }

  String? validateCompanyHouseNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.companyHouseNumberIsRequired;
    }
    return null;
  }

  String? validateCompanyPostId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.companyPostIdIsRequired;
    }
    return null;
  }

  String? validateCompanyCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.companyCityIsRequired;
    }
    return null;
  }
}
