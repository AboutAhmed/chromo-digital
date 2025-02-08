import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/config/routes/routes.gr.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/enums/status.dart';
import 'package:chromo_digital/core/widgets/empty_state.dart';
import 'package:chromo_digital/features/all_restaurants/view_models/restaurants/restaurants_cubit.dart';
import 'package:chromo_digital/features/all_restaurants/views/widgets/dialog/delete_restaurants_confirmation.dart';
import 'package:chromo_digital/features/all_restaurants/views/widgets/restaurant_tile.dart';
import 'package:chromo_digital/features/create_receipt/data/models/restaurant/restaurant.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class AllRestaurantsPage extends StatefulWidget {
  const AllRestaurantsPage({super.key});

  @override
  AllRestaurantsPageState createState() => AllRestaurantsPageState();
}

class AllRestaurantsPageState extends State<AllRestaurantsPage> {
  final RestaurantsCubit _restaurantsCubit = sl<RestaurantsCubit>();

  @override
  void initState() {
    _restaurantsCubit.getAllRestaurants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(LucideIcons.chevronLeft), onPressed: context.maybePop)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.push(UpdateRestaurantDetailsRoute()),
        icon: const Icon(LucideIcons.plus),
        label: Text(AppStrings.addRestaurant),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppStrings.restaurants,
              style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          BlocBuilder<RestaurantsCubit, RestaurantsState>(
            bloc: _restaurantsCubit,
            builder: (context, state) {
              return Expanded(
                child: switch (state.status) {
                  Status.initial || Status.loading => const Center(child: CircularProgressIndicator()),
                  Status.error => EmptyState.fail(
                      icon: Icon(LucideIcons.store, color: context.errorContainer, size: 80.0),
                      title: Text(state.message ?? ''),
                      onRetry: () => _restaurantsCubit.getAllRestaurants(),
                    ).center(),
                  Status.loaded => state.items.isEmpty
                      ? EmptyState(
                          icon: Icon(LucideIcons.store, color: context.secondary, size: 80.0),
                          title: Text(AppStrings.noRestaurants),
                        ).center()
                      : ListView.separated(
                          itemCount: state.items.length,
                          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 200.0, top: 16.0),
                          itemBuilder: (context, index) {
                            Restaurant item = state.items[index];
                            return RestaurantTile(
                              key: ValueKey(item.id),
                              item: item,
                              onTap: () => context.router.push(UpdateRestaurantDetailsRoute(item: item)),
                              onDelete: () => _deleteRestaurantConfirmation(item),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                        ),
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRestaurantConfirmation(Restaurant item) async {
    bool? value = (await context.showAppGeneralDialog(title: AppStrings.deleteRestaurant, child: DeleteRestaurantConfirmation())) as bool?;
    if (value != null && value) {
      _restaurantsCubit.deleteRestaurant(item.id);
    }
  }
}
