import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:chromo_digital/core/models/admin/app_user.dart';

part 'app_user_state.dart';

@LazySingleton()
class AppUserCubit extends HydratedCubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void set(AppUser user) => emit(AppUserLoaded(user));

  void updateUser(AppUser user) => emit(AppUserLoaded(user));

  Future<void> logout() async {

  }

  @override
  AppUserState? fromJson(Map<String, dynamic> json) {
    try {
      return AppUserLoaded(AppUser.fromJson(json));
    } catch (e) {
      return AppUserError(AppUser.loggedOut());
    }
  }

  @override
  Map<String, dynamic>? toJson(AppUserState state) {
      return state.user.toJson();
  }
}
