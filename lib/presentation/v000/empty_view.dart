import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/presentation/v000/loading.dart';

class EmptyView extends StatelessWidget {
  // Constants
  static const double _defaultPaddingTop = 100.0;
  static const double _defaultImageWidth = 300.0;
  static const double _defaultImageHeight = 180.0;

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
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF55CFDA),
        ),
        child: Text(
          'Reload',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Creates the content with appropriate dimensions
  Widget _createContent(double width, double height, List<Widget> widgets) {
    // Add extra space for tall screens
    if (type != EmptyType.loading && height / width > 1.3) {
      widgets.add(const SizedBox(height: _defaultImageHeight));
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
        Text(
          hintText ?? hint,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF595959),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
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

enum EmptyType { loading, noData, noNetwork, noSearch, noChat }

extension EmptyTypeExt on EmptyType {
  Widget image({
    double width = EmptyView._defaultImageWidth,
    double height = EmptyView._defaultImageHeight,
  }) {
    var name = '';
    switch (this) {
      case EmptyType.noChat:
        name = 'assets/images/nochat@3x.png';
        break;
      case EmptyType.noData:
        name = 'assets/images/nochat@3x.png';
        break;
      case EmptyType.noNetwork:
        name = 'assets/images/nowifi@3x.png';
        break;
      case EmptyType.noSearch:
        name = 'assets/images/noreach@3x.png';
        break;
      case EmptyType.loading:
        break;
    }
    return Image.asset(name, width: width, height: height);
  }

  String text() {
    switch (this) {
      case EmptyType.loading:
        return 'loading';
      case EmptyType.noData:
        return 'No Datas';
      case EmptyType.noNetwork:
        return 'No network';
      case EmptyType.noSearch:
        return 'No Sirens here yet';
      case EmptyType.noChat:
        return 'No chat';
    }
  }
}
