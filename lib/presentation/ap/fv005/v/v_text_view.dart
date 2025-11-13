import 'package:flutter/material.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/presentation/v000/v_graient_text.dart';
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
    return const Row(
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GradientText(
          textAlign: TextAlign.center,
          data: "50%",
          gradient: LinearGradient(
            colors: [Color(0xFFF4FCFF), Color(0xFF49AAFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
          ),
          style: TextStyle(fontSize: 64, fontWeight: FontWeight.w800),
        ),
        Padding(
          padding: EdgeInsets.only(top: 38),
          child: GradientText(
            textAlign: TextAlign.center,
            data: "OFF",
            gradient: LinearGradient(
              colors: [Color(0xFFF4FCFF), Color(0xFF49AAFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
            ),
            style: TextStyle(fontSize: 64, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  /// 构建小版本标题
  Widget _buildSmallVersionTitle() {
    return GradientText.linear(
      'Upgrade to VIP',
      textAlign: TextAlign.center,
      colors: const [
        Color(0xFFFF88CA),
        Color(0xFFFFA3DC),
        Color(0xFFC1F0FF),
        Color(0xFFFFB3DD),
      ],
      stops: const [0.0, 0.2, 0.3, 1.0],
      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
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
        fontSize: 14,
        fontWeight: FontWeight.w400,
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
