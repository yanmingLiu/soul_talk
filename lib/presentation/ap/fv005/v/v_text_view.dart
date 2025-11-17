import 'package:flutter/material.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/presentation/v000/v_place_text.dart';

class VTextView extends StatelessWidget {
  final String contentText;

  const VTextView({super.key, required this.contentText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        const SizedBox(height: 20),
        _buildContentCard(),
      ],
    );
  }

  /// 构建标题
  Widget _buildTitle() {
    if (DI.storage.isBest) {
      return _buildBigVersionTitle();
    } else {
      return _buildSmallVersionTitle();
    }
  }

  /// 构建大版本标题
  Widget _buildBigVersionTitle() {
    return Image.asset(
      'assets/images/title2@3x.png',
      width: 232,
      height: 58,
    );
  }

  /// 构建小版本标题
  Widget _buildSmallVersionTitle() {
    return Image.asset(
      'assets/images/title1@3x.png',
      width: 248,
      height: 31,
    );
  }

  /// 构建内容卡片
  Widget _buildContentCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [if (DI.storage.isBest) _buildSubtitle(), _buildContent()],
    );
  }

  /// 构建副标题（仅大版本显示）
  Widget _buildSubtitle() {
    return const Text(
      "Enjoy The Best Chat Experience",
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// 构建内容
  Widget _buildContent() {
    return RichTextPlaceholder(
      textKey: contentText,
      placeholders: {
        'icon': WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Image.asset('assets/images/benefit@3x.png', width: 12),
          ),
        ),
      },
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.8,
      ),
    );
  }
}
