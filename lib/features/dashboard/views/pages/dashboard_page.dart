import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/config/routes/routes.gr.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final List<DashboardItem> _tab = [
    DashboardItem(
      title: AppStrings.home,
      icon: LucideIcons.house,
      route: const HomeRoute(),
    ),
    DashboardItem(
      title: AppStrings.profile,
      icon: LucideIcons.userRound,
      route: const ProfileRoute(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: _tab.map((e) => e.route).toList(),
      builder: (context, child) => Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: context.tabsRouter.activeIndex,
          onTap: (index) => context.tabsRouter.setActiveIndex(index),
          items: _tab.map((e) => BottomNavigationBarItem(icon: Icon(e.icon), label: e.title)).toList(),
        ),
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final PageRouteInfo route;

  DashboardItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}
