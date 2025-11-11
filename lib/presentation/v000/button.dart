import 'package:flutter/material.dart';

/// 按钮样式类型
enum ButtonType { fill, border, text }

class Button extends StatefulWidget {
  const Button({
    super.key,
    this.child,
    this.borderRadius,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.height = 44.0,
    this.width,
    this.constraints,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.type = ButtonType.fill,
    this.borderColor,
    this.borderWidth = 1.0,
    this.debounceTime = 500,
  });

  final Widget? child;
  final BorderRadius? borderRadius;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final double? height;
  final double? width;
  final BoxConstraints? constraints;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  /// 按钮样式
  final ButtonType type;

  /// 边框颜色（仅在border样式下有效）
  final Color? borderColor;

  /// 边框宽度（仅在border样式下有效）
  final double borderWidth;

  /// 防抖时间（毫秒）
  final int debounceTime;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  DateTime? _lastPressTime;

  /// 防抖点击处理
  void _handleTap() {
    if (widget.onTap == null) return;

    final now = DateTime.now();
    if (_lastPressTime != null &&
        now.difference(_lastPressTime!).inMilliseconds < widget.debounceTime) {
      return;
    }

    _lastPressTime = now;
    widget.onTap!();
  }

  /// 根据样式生成装饰
  BoxDecoration _getDecoration(BorderRadius br) {
    switch (widget.type) {
      case ButtonType.fill:
        return BoxDecoration(color: widget.color, borderRadius: br);
      case ButtonType.border:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: br,
          border: Border.all(
            color:
                widget.borderColor ??
                widget.color ??
                Theme.of(context).primaryColor,
            width: widget.borderWidth,
          ),
        );
      case ButtonType.text:
        return BoxDecoration(color: Colors.transparent, borderRadius: br);
    }
  }

  @override
  Widget build(BuildContext context) {
    final br = widget.borderRadius ?? BorderRadius.circular(16);

    // 预计算颜色，避免在InkWell中重复计算
    final interactionColor =
        widget.color?.withValues(alpha: 0.5) ??
        (widget.borderColor ?? widget.color ?? Colors.transparent);

    Widget buttonChild = Container(
      height: widget.height,
      width: widget.width,
      constraints: widget.constraints,
      padding: widget.padding,
      decoration: _getDecoration(br),
      child: widget.child ?? const SizedBox.shrink(),
    );

    // 如果没有点击事件，直接返回容器，避免InkWell开销
    if (widget.onTap == null) {
      return widget.margin != null
          ? Padding(padding: widget.margin!, child: buttonChild)
          : buttonChild;
    }

    buttonChild = InkWell(
      onTap: _handleTap,
      focusColor: widget.focusColor ?? interactionColor,
      hoverColor: widget.hoverColor ?? interactionColor,
      highlightColor: widget.highlightColor ?? interactionColor,
      borderRadius: br,
      child: buttonChild,
    );

    return widget.margin != null
        ? Padding(padding: widget.margin!, child: buttonChild)
        : buttonChild;
  }
}
