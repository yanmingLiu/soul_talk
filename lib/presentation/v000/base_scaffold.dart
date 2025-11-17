import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  const BaseScaffold({
    super.key,
    required this.body,
    this.extendBody = true,
    this.extendBodyBehindAppBar = true,
    this.appBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
        ),
        Scaffold(
          appBar: appBar,
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          backgroundColor: backgroundColor,
          body: body,
        ),
      ],
    );
  }
}
