import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:photo_manager/photo_manager.dart';

class AppImage extends StatelessWidget {
  final Widget _child;

  AppImage.network({
    super.key,
    required final String imageUrl,
    final Map<String, String>? httpHeaders,
    final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder,
    final Widget Function(BuildContext, String)? placeholder,
    final Widget Function(BuildContext, String, DownloadProgress)? progressIndicatorBuilder,
    final Widget Function(BuildContext, String, dynamic)? errorWidget,
    final Duration? fadeOutDuration,
    final Curve? fadeOutCurve,
    final Duration? fadeInDuration,
    final Curve? fadeInCurve,
    final double? width,
    final double? height,
    final BoxFit? fit,
    final AlignmentGeometry? alignment,
    final ImageRepeat? repeat,
    final bool? matchTextDirection,
    final bool? useOldImageOnUrlChange,
    final Color? color,
    final FilterQuality? filterQuality,
    final BlendMode? colorBlendMode,
    final Duration? placeholderFadeInDuration,
    final int? memCacheWidth,
    final int? memCacheHeight,
    final String? cacheKey,
    final int? maxWidthDiskCache,
    final int? maxHeightDiskCache,
    final BorderRadius? borderRadius,
  }) : _child = _NetworkImage(
          imageUrl: imageUrl,
          httpHeaders: httpHeaders,
          imageBuilder: imageBuilder,
          placeholder: placeholder,
          progressIndicatorBuilder: progressIndicatorBuilder,
          errorWidget: errorWidget,
          fadeOutDuration: fadeOutDuration,
          fadeOutCurve: fadeOutCurve,
          fadeInDuration: fadeInDuration,
          fadeInCurve: fadeInCurve,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
          useOldImageOnUrlChange: useOldImageOnUrlChange,
          color: color,
          filterQuality: filterQuality,
          colorBlendMode: colorBlendMode,
          placeholderFadeInDuration: placeholderFadeInDuration,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          cacheKey: cacheKey,
          maxWidthDiskCache: maxWidthDiskCache,
          maxHeightDiskCache: maxHeightDiskCache,
          borderRadius: borderRadius,
        );

  AppImage.file({
    super.key,
    required File file,
    final double? width,
    final double? height,
    final Color? color,
    final BoxFit? fit,
    final BorderRadius? borderRadius,
  }) : _child = _ImageFile(
          file: file,
          width: width,
          height: height,
          color: color,
          fit: fit,
          borderRadius: borderRadius,
        );

  AppImage.asset(
    final String assetName, {
    super.key,
    final double? width,
    final double? height,
    final Color? color,
    final BoxFit? fit,
    final BorderRadius? borderRadius,
  }) : _child = _ImageAsset(
          assetName,
          width: width,
          height: height,
          color: color,
          fit: fit,
          borderRadius: borderRadius,
        );

  AppImage.svg(
    String assetsName, {
    super.key,
    final double? width,
    final double? height,
    final Color? color,
    final BoxFit? fit,
    final EdgeInsets? padding,
  }) : _child = _SvgAssets(
          assetsName,
          width: width,
          height: height,
          color: color,
          fit: fit,
          padding: padding,
        );

  AppImage.assetEntity(
    AssetEntity asset, {
    super.key,
    final double? width,
    final double? height,
    final Color? color,
    final BoxFit? fit = BoxFit.cover,
    final BorderRadius? borderRadius,
  }) : _child = _ImageAssetEntity(
          asset,
          width: width,
          height: height,
          color: color,
          fit: fit,
          borderRadius: borderRadius,
        );

  @override
  Widget build(BuildContext context) => _child;
}

class _NetworkImage extends StatelessWidget {
  final String imageUrl;
  final Map<String, String>? httpHeaders;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, DownloadProgress)? progressIndicatorBuilder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Duration fadeOutDuration;
  final Curve fadeOutCurve;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final bool useOldImageOnUrlChange;
  final Color? color;
  final FilterQuality filterQuality;
  final BlendMode? colorBlendMode;
  final Duration? placeholderFadeInDuration;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final String? cacheKey;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final BorderRadius borderRadius;

  const _NetworkImage({
    required this.imageUrl,
    this.httpHeaders,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    final Duration? fadeOutDuration,
    final Curve? fadeOutCurve,
    final Duration? fadeInDuration,
    final Curve? fadeInCurve,
    this.width,
    this.height,
    this.fit,
    final AlignmentGeometry? alignment,
    final ImageRepeat? repeat,
    final bool? matchTextDirection,
    final bool? useOldImageOnUrlChange,
    this.color,
    final FilterQuality? filterQuality,
    final BorderRadius? borderRadius,
    this.colorBlendMode,
    this.placeholderFadeInDuration,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
  })  : fadeOutDuration = fadeOutDuration ?? const Duration(milliseconds: 1000),
        fadeOutCurve = fadeOutCurve ?? Curves.easeOut,
        fadeInDuration = fadeInDuration ?? const Duration(milliseconds: 500),
        fadeInCurve = fadeInCurve ?? Curves.easeIn,
        alignment = alignment ?? Alignment.center,
        repeat = repeat ?? ImageRepeat.noRepeat,
        matchTextDirection = matchTextDirection ?? false,
        useOldImageOnUrlChange = useOldImageOnUrlChange ?? false,
        filterQuality = filterQuality ?? FilterQuality.low,
        borderRadius = borderRadius ?? BorderRadius.zero;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return placeholder?.call(context, imageUrl) ?? Container();
    }

    /// in case your app is dealing with web
    if (kIsWeb) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
          color: color,
          filterQuality: filterQuality,
          colorBlendMode: colorBlendMode,
        ),
      );
    }
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        httpHeaders: httpHeaders,
        placeholder: placeholder,
        progressIndicatorBuilder: progressIndicatorBuilder,
        fadeInDuration: fadeInDuration,
        fadeOutDuration: fadeOutDuration,
        maxWidthDiskCache: maxWidthDiskCache,
        matchTextDirection: matchTextDirection,
        width: width,
        errorWidget: errorWidget,
        maxHeightDiskCache: maxHeightDiskCache,
        placeholderFadeInDuration: placeholderFadeInDuration,
        fadeInCurve: fadeInCurve,
        fadeOutCurve: fadeOutCurve,
        filterQuality: filterQuality,
        fit: fit,
        height: height,
        memCacheWidth: memCacheWidth,
        repeat: repeat,
        useOldImageOnUrlChange: useOldImageOnUrlChange,
        imageBuilder: imageBuilder,
        memCacheHeight: memCacheHeight,
        key: key,
        cacheKey: cacheKey,
        color: color,
        colorBlendMode: colorBlendMode,
      ),
    );
  }
}

class _ImageFile extends StatelessWidget {
  final File file;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  final BorderRadius borderRadius;

  const _ImageFile({
    required this.file,
    this.width,
    this.height,
    this.color,
    this.fit,
    final BorderRadius? borderRadius,
  })  : borderRadius = borderRadius ?? BorderRadius.zero,
        super();

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          file.path,
          width: width,
          height: height,
          color: color,
          fit: fit,
        ),
      );
    }
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.file(
        file,
        width: width,
        height: height,
        color: color,
        fit: fit,
      ),
    );
  }
}

class _ImageAsset extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  final BorderRadius borderRadius;

  const _ImageAsset(
    this.assetName, {
    this.width,
    this.height,
    this.color,
    this.fit,
    final BorderRadius? borderRadius,
  })  : borderRadius = borderRadius ?? BorderRadius.zero,
        super();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        assetName,
        width: width,
        height: height,
        color: color,
        fit: fit,
      ),
    );
  }
}

class _SvgAssets extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final EdgeInsets? padding;

  const _SvgAssets(
    this.assetName, {
    this.width,
    this.height,
    this.color,
    final BoxFit? fit,
    this.padding,
  })  : fit = fit ?? BoxFit.contain,
        super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SvgPicture.asset(
        assetName,
        width: width,
        height: height,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        fit: fit,
      ),
    );
  }
}

class _ImageAssetEntity extends StatelessWidget {
  final AssetEntity asset;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  final BorderRadius borderRadius;

  const _ImageAssetEntity(
    this.asset, {
    this.width,
    this.height,
    this.color,
    this.fit,
    final BorderRadius? borderRadius,
  })  : borderRadius = borderRadius ?? BorderRadius.zero,
        super();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: borderRadius,
            child: FutureBuilder(
              future: asset.thumbnailData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  if (asset.type == AssetType.video) return const SizedBox.shrink();
                  return Icon(Icons.image, color: Colors.grey.withAlpha(130), size: 40.0).center();
                } else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    width: width,
                    height: height,
                    color: color,
                    fit: fit,
                  );
                }
                return const Placeholder();
              },
            ),
          ),
        ),
        if (asset.type == AssetType.video)
          CircleAvatar(
            backgroundColor: context.onPrimary.withAlpha(130),
            radius: 24.0,
            child: Icon(LucideIcons.play, color: context.onPrimary, size: 36.0),
          ).center(),
      ],
    );
  }
}
