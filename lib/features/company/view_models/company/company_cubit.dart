import 'package:bloc_state_gen/bloc_state_gen.dart';
import 'package:chromo_digital/core/resources/data_state.dart';
import 'package:chromo_digital/features/company/data/models/company.dart';
import 'package:chromo_digital/features/company/data/repositories/company_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'company_cubit.s.dart';

part 'company_state.dart';

@LazySingleton()
@BlocStateGen()
class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository _repository;

  CompanyCubit(this._repository) : super(CompanyInitial());

  Future<void> getCompany() async {
    emit(CompanyLoading());
    DataState<Company> result = await _repository.getCompany();
    result.when(
      success: (item) => emit(CompanyLoaded(item: item)),
      onError: (failure) => emit(CompanyError(message: failure.message)),
    );
  }

  Future<void> saveCompany(Company item) async {
    DataState<int> result = await _repository.saveCompany(item);
    result.when(
      success: (value) {
        if (value > 0) emit(CompanyLoaded(item: item));
      },
      onError: (failure) => emit(CompanyError(message: failure.message)),
    );
  }

  Future<void> updateCompany(Company item) async {
    DataState<int> result = await _repository.updateCompany(item);
    result.when(
      success: (value) {
        if (value > 0) emit(CompanyLoaded(item: item));
      },
      onError: (failure) => emit(CompanyError(message: failure.message)),
    );
  }

  void toggleCompanyInfo(bool value) {
    final currentState = state;
    if (currentState is CompanyLoaded) {
      emit(CompanyLoaded(item: currentState.item));
    }
  }
}

// void toggleCompanyInfo(bool value) {
//   final currentState = state;
//   if (currentState is CompanyLoaded) {
//     final updatedCompany = Company(
//       id: currentState.item.id,
//       name: currentState.item.name,
//       street: currentState.item.street,
//       houseNumber: currentState.item.houseNumber,
//       postId: currentState.item.postId,
//       city: currentState.item.city,
//       createdAt: currentState.item.createdAt,
//       showCompanyInfo: value,
//     );
//
//     emit(CompanyLoaded(item: updatedCompany));
//   }
// }
