import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/enums/status.dart';
import 'package:chromo_digital/core/widgets/empty_state.dart';
import 'package:chromo_digital/features/all_purposes/view_models/purposes/purposes_cubit.dart';
import 'package:chromo_digital/features/all_purposes/views/widgets/dialog/add_purpose_dialog.dart';
import 'package:chromo_digital/features/all_purposes/views/widgets/dialog/delete_purpose_confirmation.dart';
import 'package:chromo_digital/features/all_purposes/views/widgets/purpose_tile.dart';
import 'package:chromo_digital/features/create_receipt/data/models/purpose/purpose.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class AllPurposesPage extends StatefulWidget {
  const AllPurposesPage({super.key});

  @override
  State<AllPurposesPage> createState() => _AllPurposesPageState();
}

class _AllPurposesPageState extends State<AllPurposesPage> {
  final PurposesCubit _purposesCubit = sl<PurposesCubit>();

  @override
  void initState() {
    super.initState();
    _purposesCubit.getAllPurposes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(LucideIcons.chevronLeft), onPressed: context.maybePop)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPurpose,
        icon: const Icon(LucideIcons.plus),
        label: Text(AppStrings.addPurpose),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppStrings.purposes,
              style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          BlocBuilder<PurposesCubit, PurposesState>(
            bloc: _purposesCubit,
            builder: (context, state) {
              return Expanded(
                child: switch (state.status) {
                  Status.initial || Status.loading => const Center(child: CircularProgressIndicator()),
                  Status.error => EmptyState.fail(
                      icon: Icon(LucideIcons.clipboardPenLine, color: context.errorContainer, size: 80.0),
                      title: Text(state.message ?? ''),
                      onRetry: () => _purposesCubit.getAllPurposes(),
                    ).center(),
                  Status.loaded => state.items.isEmpty
                      ? EmptyState(
                          icon: Icon(LucideIcons.clipboardPenLine),
                          title: Text(AppStrings.purposes),
                          subtitle: Text(AppStrings.yourPurposesWillBeDisplayedHere),
                        ).paddingOnly(bottom: 200.0).center()
                      : ListView.separated(
                          itemCount: state.items.length,
                          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 200.0, top: 16.0),
                          itemBuilder: (context, index) {
                            var item = state.items[index];
                            return PurposeTile(
                              item: item,
                              onDelete: () => _deletePurposeConfirmation(item),
                              onEdit: () => _editPurpose(item),
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

  Future<void> _deletePurposeConfirmation(Purpose item) async {
    bool? value = (await context.showAppGeneralDialog(title: AppStrings.deletePurpose, child: DeletePurposeConfirmation())) as bool?;
    if (value != null && value) {
      _purposesCubit.deletePurpose(item.id);
    }
  }

  Future<void> _editPurpose(Purpose item) async {
    Purpose? result = (await context.showAppGeneralDialog(title: AppStrings.updatePurpose, child: AddPurposeDialog(item: item))) as Purpose?;
    if (result != null) _purposesCubit.updatePurpose(result);
  }

  void _addPurpose() async {
    Purpose? item = (await context.showAppGeneralDialog(title: AppStrings.addPurpose, child: AddPurposeDialog())) as Purpose?;
    if (item != null) _purposesCubit.savePurpose(item);
  }
}
