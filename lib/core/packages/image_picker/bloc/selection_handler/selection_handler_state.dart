part of 'selection_handler_cubit.dart';

@immutable
sealed class SelectionHandlerState {
  final List<File> items;
  final bool multiSelection;
  final int maxItemsLimit;
  final bool limitReached;

  const SelectionHandlerState({
    this.items = const [],
    this.multiSelection = false,
    this.maxItemsLimit = maxImagesLimit,
    this.limitReached = false,
  });

  // copy with
  SelectionHandlerState copyWith({
    List<File>? items,
    bool? multiSelection,
    bool? limitReached = false,
    int? maxItemsLimit,
  });
}

final class SelectionHandlerUpdate extends SelectionHandlerState {
  const SelectionHandlerUpdate({
    super.items,
    super.multiSelection,
    super.maxItemsLimit,
    super.limitReached,
  });

  @override
  SelectionHandlerState copyWith({
    List<File>? items,
    bool? multiSelection,
    bool? limitReached,
    int? maxItemsLimit,
  }) {
    return SelectionHandlerUpdate(
      items: items ?? super.items,
      multiSelection: multiSelection ?? super.multiSelection,
      limitReached: limitReached ?? super.limitReached,
      maxItemsLimit: maxItemsLimit ?? super.maxItemsLimit,
    );
  }
}
