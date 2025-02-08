import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/enums/status.dart';
import 'package:chromo_digital/core/widgets/empty_state.dart';
import 'package:chromo_digital/features/all_participants/view_models/participants/participants_cubit.dart';
import 'package:chromo_digital/features/all_participants/views/widgets/dialog/add_participant_dialog.dart';
import 'package:chromo_digital/features/all_participants/views/widgets/dialog/delete_participant_confirmation.dart';
import 'package:chromo_digital/features/all_participants/views/widgets/participant_tile.dart';
import 'package:chromo_digital/features/create_receipt/data/models/Participant/participants.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class AllParticipantsPage extends StatefulWidget {
  const AllParticipantsPage({super.key});

  @override
  State<AllParticipantsPage> createState() => _AllParticipantsPageState();
}

class _AllParticipantsPageState extends State<AllParticipantsPage> {
  final ParticipantsCubit _participantsCubit = sl<ParticipantsCubit>();

  @override
  void initState() {
    super.initState();
    _participantsCubit.getAllParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(LucideIcons.chevronLeft), onPressed: context.maybePop)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addParticipant,
        icon: const Icon(LucideIcons.plus),
        label: Text(AppStrings.addParticipant),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppStrings.participants,
              style: context.titleMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          BlocBuilder<ParticipantsCubit, ParticipantsState>(
            bloc: _participantsCubit,
            builder: (context, state) {
              return Expanded(
                child: switch (state.status) {
                  Status.initial || Status.loading => const Center(child: CircularProgressIndicator()),
                  Status.error => EmptyState.fail(
                      icon: Icon(LucideIcons.store, color: context.errorContainer, size: 80.0),
                      title: Text(state.message ?? ''),
                      onRetry: () => _participantsCubit.getAllParticipants(),
                    ).center(),
                  Status.loaded => state.items.isEmpty
                      ? EmptyState(
                          icon: Icon(LucideIcons.briefcaseBusiness),
                          title: Text(AppStrings.noParticipants),
                          subtitle: Text(AppStrings.yourParticipantsWillBeDisplayedHere),
                        ).paddingOnly(bottom: 200.0).center()
                      : ListView.separated(
                          itemCount: state.items.length,
                          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 200.0, top: 16.0),
                          itemBuilder: (context, index) {
                            Participant item = state.items[index];
                            return ParticipantTile(
                              item: item,
                              onDelete: () => _deleteParticipantConfirmation(item),
                              onEdit: () => _editParticipant(item),
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

  Future<void> _deleteParticipantConfirmation(Participant item) async {
    bool? value = (await context.showAppGeneralDialog(title: AppStrings.deleteParticipant, child: DeleteParticipantConfirmation())) as bool?;
    if (value != null && value) {
      _participantsCubit.deleteParticipant(item.id);
    }
  }

  Future<void> _editParticipant(Participant item) async {
    Participant? result =
        (await context.showAppGeneralDialog(title: AppStrings.updateParticipant, child: AddParticipantDialog(item: item))) as Participant?;
    if (result != null) _participantsCubit.updateParticipant(result);
  }

  void _addParticipant() async {
    Participant? item = (await context.showAppGeneralDialog(title: AppStrings.addParticipant, child: AddParticipantDialog())) as Participant?;
    if (item != null) _participantsCubit.saveAParticipant(item);
  }
}
