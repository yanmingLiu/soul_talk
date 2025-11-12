import 'package:flutter/material.dart';
import 'package:soul_talk/domain/entities/message.dart';

class _TipsStyle {
  _TipsStyle._();

  static const double fontSize = 10.0;
  static const double borderRadius = 16.0;
  static const EdgeInsets padding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );
  static const Color backgroundColor = Color(0x80000000);
  static const FontWeight fontWeight = FontWeight.w400;
  static const Color textColor = Colors.white;

  static const TextStyle textStyle = TextStyle(
    color: textColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );

  static const BorderRadius borderRadiusGeometry = BorderRadius.all(
    Radius.circular(borderRadius),
  );
}

/// Tips内容组件
class VTips extends StatelessWidget {
  const VTips({super.key, required this.msg});

  final Message msg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: _TipsStyle.padding,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: const BoxDecoration(
          color: _TipsStyle.backgroundColor,
          borderRadius: _TipsStyle.borderRadiusGeometry,
        ),

        child: Text(
          msg.answer ?? '',
          textAlign: TextAlign.center,
          style: _TipsStyle.textStyle, // 使用缓存的样式对象
        ),
      ),
    );
  }
}
