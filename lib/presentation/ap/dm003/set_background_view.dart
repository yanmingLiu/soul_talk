import 'package:flutter/material.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';

class SettingMessageBackground extends StatelessWidget {
  const SettingMessageBackground({
    super.key,
    required this.onTapUpload,
    required this.onTapUseChat,
    required this.isUseChater,
  });

  final VoidCallback onTapUpload;
  final VoidCallback onTapUseChat;
  final bool isUseChater;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF00120A),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              const Text(
                'Set chat background',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              isUseChater
                  ? _buildButton('Upload a photo', onTapUpload)
                  : _buildSelectButton('Upload a photo'),
              isUseChater
                  ? _buildSelectButton('Use avatar')
                  : _buildButton('Use avatar', onTapUseChat),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String title, VoidCallback onTap) {
    return VButton(
      onTap: onTap,
      height: 48,
      borderRadius: BorderRadius.circular(8),
      color: const Color(0xFF85FFCD),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectButton(String title) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: const Color(0xFF727374), width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(Icons.check, color: Color(0xFF85FFCD), size: 20),
        ],
      ),
    );
  }
}
