import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget? appBar;

  const BaseScaffold({
    super.key,
    required this.body,
    this.extendBody = true,
    this.extendBodyBehindAppBar = true,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          ),
          body,
        ],
      ),
    );
  }
}
