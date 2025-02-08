import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/features/create_receipt/views/widgets/tabs/participant_tab.dart';
import 'package:chromo_digital/features/create_receipt/views/widgets/tabs/purpose_tab.dart';
import 'package:chromo_digital/features/create_receipt/views/widgets/tabs/restaurant_bill_tab.dart';
import 'package:chromo_digital/features/create_receipt/views/widgets/tabs/restaurant_tab.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class CreateReceiptPage extends StatefulWidget {
  const CreateReceiptPage({super.key});

  @override
  State<CreateReceiptPage> createState() => _CreateReceiptPageState();
}

class _CreateReceiptPageState extends State<CreateReceiptPage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabs = [
      RestaurantTab(
        controller: _pageController,
      ),
      ParticipantTab(
        controller: _pageController,
      ),
      PurposeTab(
        controller: _pageController,
      ),
      RestaurantBillTab(
        controller: _pageController,
      ),
    ];
  }

  List<Widget> _tabs = [];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, __) async {
        if (didPop) {
          return;
        }
        await _onBackPressed();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(LucideIcons.chevronLeft),
            onPressed: () async => await _onBackPressed(),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          spacing: 12.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.createCateringReceipt,
              style: context.titleLarge!.copyWith(fontWeight: FontWeight.w600),
            ).padding(EdgeInsets.symmetric(horizontal: 16.0)),
            PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: _tabs.length,
              itemBuilder: (context, index) => _tabs[index],
            ).expanded(),
          ],
        ),
      ),
    );
  }

  Future<void> _onBackPressed() async {
    // if page is not first then move controller else pop page
    if (_pageController.page! > 0) {
      await _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

class ReceiptItem {
  final String title;
  final IconData icon;
  final Widget tab;

  ReceiptItem({
    required this.title,
    required this.icon,
    required this.tab,
  });
}
