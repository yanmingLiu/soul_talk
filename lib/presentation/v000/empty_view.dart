import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/presentation/v000/loading.dart';

class EmptyView extends StatelessWidget {
  // Constants
  static const double _defaultPaddingTop = 100.0;
  static const double _defaultImageSize = 200.0;

  const EmptyView({
    super.key,
    required this.type,
    this.hintText,
    this.image,
    this.physics,
    this.size,
    this.loadingIconColor,
    this.onReload,
    this.paddingTop,
  });

  final EmptyType type;

  final String? hintText;
  final Widget? image;
  final Size? size;
  final ScrollPhysics? physics;
  final Color? loadingIconColor;
  final VoidCallback? onReload;
  final double? paddingTop;

  Widget _buildReloadButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onReload,
      child: Container(
        width: 81,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF85FFCD),
        ),
        child: Text(
          'reload',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Creates the content with appropriate dimensions
  Widget _createContent(double width, double height, List<Widget> widgets) {
    // Add extra space for tall screens
    if (type != EmptyType.loading && height / width > 1.3) {
      widgets.add(const SizedBox(height: _defaultImageSize));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      child: Container(
        width: width,
        height: height - kToolbarHeight,
        padding: EdgeInsets.only(top: paddingTop ?? _defaultPaddingTop),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    if (type == EmptyType.loading) {
      // Loading state - show activity indicator
      widgets.add(Loading.activityIndicator());
    } else {
      // Empty or No Network state
      // Use custom image if provided, otherwise use default for the type
      widgets.add(image ?? type.image());

      // Add hint text
      final String hint = type.text();
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            hintText ?? hint,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );

      // Add reload button for network error if callback is provided
      if (type == EmptyType.noNetwork && onReload != null) {
        widgets.add(const SizedBox(height: 16));
        widgets.add(_buildReloadButton());
      }
    }

    // Use provided size or get screen dimensions
    final Size screenSize = size ?? Size(Get.width, Get.height);
    return _createContent(screenSize.width, screenSize.height, widgets);
  }
}

enum EmptyType { loading, noData, noNetwork, noSearch }

extension EmptyTypeExt on EmptyType {
  Widget image({
    double width = EmptyView._defaultImageSize,
    double height = EmptyView._defaultImageSize,
  }) {
    return Icon(Icons.error_outline);
    var name = 'assets/images/e_no_load.png';
    switch (this) {
      case EmptyType.noData:
        name = 'assets/images/e_no_data.png';
        break;
      case EmptyType.noNetwork:
        name = 'assets/images/e_no_network.png';
        break;
      case EmptyType.noSearch:
        name = 'assets/images/e_no_search.png';
        break;
      case EmptyType.loading:
        name = 'assets/images/e_no_load.png';
        break;
    }
    return Image.asset(name, width: width, height: height);
  }

  /// Returns the localized text message for this empty state type
  String text() {
    switch (this) {
      case EmptyType.loading:
        return 'loading';
      case EmptyType.noData:
        return 'noData';
      case EmptyType.noNetwork:
        return 'noNetwork';
      case EmptyType.noSearch:
        return 'noSearch';
    }
  }
}
