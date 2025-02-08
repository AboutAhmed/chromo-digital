import 'package:flutter/material.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:chromo_digital/core/widgets/app_image.dart';
import 'package:photo_manager/photo_manager.dart';

class LargeAssetGalleryViewer extends StatelessWidget {
  final AssetEntity asset;

  const LargeAssetGalleryViewer({
    super.key,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: context.width * 0.85,
        maxHeight: context.height * 0.85,
      ),
      child: AppImage.assetEntity(asset, fit: BoxFit.contain),
    );
  }
}
