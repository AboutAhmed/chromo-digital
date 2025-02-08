import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/config/routes/routes.gr.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:flutter/material.dart';

part 'auto_router_observer.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  /// make all strings private because we don't need to access them outside of this file
  /// welcome
  static const _initialLocalization = '/initial-localization';

  /// AUTH
  // static const String _auth = '/auth';
  // static const String _login = '/login';
  // static const String _forgotPassword = '/forgot-password';

  // static const String _editProfile = '/edit-profile';
  //
  // static const String _signUp = '/sign-up';
  //
  // static const String _resetPassword = 'reset-password';

  /// DASHBOARD
  static const _dashboard = '/dashboard';
  static const _home = 'home';
  static const _profile = 'profile';

  /// SETTINGS
  static const String _settings = '/settings';
  static const String _language = 'language';
  static const String _theme = 'theme';

  static const _createReceipt = '/create-receipt';
  static const _restaurants = '/restaurants';
  static const _updateRestaurants = '/restaurant-update';
  static const _participants = '/participants';
  static const _purposes = '/purposes';
  static const _pdfViewer = '/pdf-viewer';
  static const _receipts = '/receipts';
  static const _company = '/company';

  /// TASKS

  /// help and support
  // static const String _helpAndSupport = '/help-and-support';
  // static const String _aboutUs = 'about-us';
  // static const String _privacyPolicy = 'privacy-policy';
  // static const String _howToUse = 'how-to-use';
  // static const String _termsAndConditions = 'terms-and-conditions';

  /// [RouteType.adaptive] will use adaptive page transition
  /// [RoutType.cupertino] will use IOS default page transition
  /// [RoutType.material] will use Android default page transition
  ///
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: WelcomeRoute.page, initial: true),
        AutoRoute(page: InitialLocalizationRoute.page, path: _initialLocalization),
        // AutoRoute(page: HomeRoute.page, path: _home),
        /// DASHBOARD
        AutoRoute(
          page: DashboardRoute.page,
          path: _dashboard,
          children: [
            AutoRoute(page: HomeRoute.page, path: _home, initial: true),
            AutoRoute(page: ProfileRoute.page, path: _profile),
          ],
        ),

        AutoRoute(
          page: SettingsEmptyRoute.page,
          path: _settings,
          children: [
            AutoRoute(page: SettingsRoute.page, initial: true),
            AutoRoute(page: LocalizationRoute.page, path: _language),
            AutoRoute(page: ThemeRoute.page, path: _theme),
          ],
        ),

        AutoRoute(page: CreateReceiptRoute.page, path: _createReceipt),
        // AutoRoute(page: CreatedReceiptRoute.page, path: _createdReceipt),
        AutoRoute(page: AllRestaurantsRoute.page, path: _restaurants),
        AutoRoute(page: UpdateRestaurantDetailsRoute.page, path: _updateRestaurants),
        AutoRoute(page: AllParticipantsRoute.page, path: _participants),
        AutoRoute(page: AllPurposesRoute.page, path: _purposes),
        AutoRoute(page: ReceiptViewerRoute.page, path: _pdfViewer),
        AutoRoute(page: ReceiptsRoute.page, path: _receipts),
        AutoRoute(page: CompanyUpdateRoute.page, path: _company),
      ];

  List<RouteObserver> get observers => [RouteObserver()];
}
