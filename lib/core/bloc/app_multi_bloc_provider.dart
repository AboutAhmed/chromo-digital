import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chromo_digital/core/bloc/user/app_user_cubit.dart';
import 'package:chromo_digital/core/di/service_locator.dart';

class AppMultiBlocProvider extends StatelessWidget {
  final Widget child;

  const AppMultiBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// add your blocs here
        BlocProvider<AppUserCubit>(create: (_) => sl<AppUserCubit>()),
      ],
      child: child,
    );
  }
}
