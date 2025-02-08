part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {
  final AppUser user;

  const AppUserState({required this.user});
}

final class AppUserInitial extends AppUserState {
  AppUserInitial() : super(user: AppUser.loggedOut());
}

final class AppUserLoaded extends AppUserState {
  const AppUserLoaded(AppUser user) : super(user: user);
}

final class AppUserError extends AppUserState {
  const AppUserError(AppUser user) : super(user: user);
}

final class AppUserLoading extends AppUserState {
  const AppUserLoading(AppUser user) : super(user: user);
}
