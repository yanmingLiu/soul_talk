import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VImage extends StatelessWidget {
  const VImage({
    super.key,
    this.url,
    this.width,
    this.height,
    this.shape,
    this.border,
    this.borderRadius,
    this.color,
    this.cacheWidth,
    this.cacheHeight,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxShape? shape;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final Color? color;
  final int? cacheWidth;
  final int? cacheHeight;

  String get urlSuffix => '?x-oss-process=image/resize,p_50';

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return placeholder();
    }

    var imageUrl = url!;
    if (cacheHeight != null || cacheWidth != null) {
      imageUrl += urlSuffix;
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      cacheKey: imageUrl,
      placeholder: (context, url) => placeholder(),
      errorWidget: (context, url, error) => placeholder(),
      color: color,
    );

    // Apply shape and border
    if (border != null || shape != null) {
      imageWidget = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: shape ?? BoxShape.rectangle,
          border: border,
          borderRadius: shape == BoxShape.circle ? null : borderRadius,
        ),
        child: ClipRRect(
          borderRadius: shape == BoxShape.circle
              ? BorderRadius.circular((width ?? height ?? 0) / 2)
              : (borderRadius ?? BorderRadius.zero),
          child: imageWidget,
        ),
      );
    } else {
      imageWidget = ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget placeholder() {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0x30808080),
        borderRadius: borderRadius,
        border: border,
      ),
      child: const Icon(
        Icons.image_rounded,
        size: 26,
        color: Color(0xFF808080),
      ),
    );
  }
}
