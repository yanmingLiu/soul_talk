import 'package:flutter/material.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';

class VAlert extends StatelessWidget {
  const VAlert({
    super.key,
    this.title,
    this.message,
    this.messageWidget,
    this.cancelText,
    this.confirmText,
    this.onCancel,
    this.onConfirm,
  });

  final String? title;
  final String? message;
  final Widget? messageWidget;
  final String? cancelText;
  final String? confirmText;
  final void Function()? onCancel;
  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
      ),
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title?.isNotEmpty == true)
            _buildText(title, 18, FontWeight.w400, Colors.black),
          _buildText(message, 14, FontWeight.w400, Color(0xFF595959)),
          if (messageWidget != null) messageWidget!,
          const SizedBox(height: 10),
          Row(
            spacing: 15,
            children: [
              Expanded(
                child: VButton(
                  onTap: () {
                    onCancel ?? VDialog.dismiss();
                  },
                  height: 44,
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Text(
                      cancelText ?? 'Cancel',
                      style: const TextStyle(
                        color: Color(0xFF434343),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: VButton(
                  onTap: onConfirm,
                  margin: const EdgeInsets.only(top: 8),
                  color: const Color(0xFF55CFDA),
                  height: 44,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Text(
                      confirmText ?? 'Confirm',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildText(
    String? text,
    double fontSize,
    FontWeight fontWeight,
    Color color,
  ) {
    if (text?.isNotEmpty != true) return const SizedBox.shrink();
    return Text(
      text!,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
