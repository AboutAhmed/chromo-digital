import 'package:chromo_digital/core/bloc/helper.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'service_locator.config.dart';

/// sl is the service locator
final sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  await sl.init();
  setupServiceLocator();
}
void setupServiceLocator() {
  sl.registerLazySingleton(() => Handler<String>(''));
}
