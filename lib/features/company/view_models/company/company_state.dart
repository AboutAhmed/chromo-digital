part of 'company_cubit.dart';

@immutable
sealed class CompanyState {
  const CompanyState();
}

final class CompanyInitial extends CompanyState {
  const CompanyInitial();
}

final class CompanyLoading extends CompanyState {
  const CompanyLoading();
}

final class CompanyLoaded extends CompanyState {
  final Company item;

  const CompanyLoaded({required this.item});
}

final class CompanyError extends CompanyState {
  final String message;

  const CompanyError({required this.message});
}
