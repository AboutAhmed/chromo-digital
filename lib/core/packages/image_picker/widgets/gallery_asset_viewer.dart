import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:chromo_digital/core/packages/image_picker/bloc/selection_handler/selection_handler_cubit.dart';
import 'package:chromo_digital/core/widgets/app_image.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryAssetViewer extends StatelessWidget {
  final SelectionHandlerCubit? selectionHandler;
  final AssetEntity asset;

  const GalleryAssetViewer(
    this.asset, {
    required this.selectionHandler,
    super.key,
    // this.selected,
  });

  @override
  Widget build(BuildContext context) {
    bool multiSelection = selectionHandler?.state.multiSelection ?? false;
    return GestureDetector(
      onTap: () => selectionHandler?.addEntity(asset),
      onLongPress: () {},
      child: Stack(
        children: [
          Positioned.fill(child: AppImage.assetEntity(asset)),
          Positioned(
            top: 4.0,
            right: 4.0,
            child: BlocBuilder<SelectionHandlerCubit, SelectionHandlerState>(
              bloc: selectionHandler,
              builder: (context, selectedItems) {
                return FutureBuilder(
                  future: asset.file,
                  builder: (context, snapshot) {
                    bool selected = selectedItems.items.any((f) => f.path == snapshot.data?.path);
                    if (selected) {
                      int index = selectedItems.items.indexWhere((element) => element.path == snapshot.data?.path);
                      return Container(
                        decoration: BoxDecoration(
                          color: context.primary,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4.0),
                        child: multiSelection
                            ? SizedBox.square(
                                dimension: 18.0,
                                child: FittedBox(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(color: context.onPrimary, fontSize: 12.0),
                                  ),
                                ),
                              )
                            : Icon(Icons.check, color: context.onPrimary, size: 18.0),
                      );
                    } else {
                      if (multiSelection != true) return const SizedBox.shrink();
                      return Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: context.onPrimary, width: 2.0)),
                        padding: const EdgeInsets.all(4.0),
                        child: const SizedBox.square(dimension: 14.0),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
