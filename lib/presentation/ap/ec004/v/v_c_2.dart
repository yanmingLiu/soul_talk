import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/domain/entities/gen_styles.dart';
import 'package:soul_talk/presentation/ap/cc002/p/edit_screen.dart';
import 'package:soul_talk/presentation/ap/ec004/v/v_c_bottom.dart';
import 'package:soul_talk/presentation/ap/ec004/v/v_c_close_btn.dart';
import 'package:soul_talk/presentation/ap/ec004/v/v_c_syle.dart';
import 'package:soul_talk/presentation/ap/ec004/v/vc_prompt.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';

class VC2 extends StatefulWidget {
  const VC2({
    super.key,
    required this.onTapGen,
    this.onDeleteImage,
    this.role,
    required this.isVideo,
    required this.onInputTextFinish,
    required this.styles,
    required this.onChooseStyles,
    this.imagePath,
    required this.undressRole,
    this.selectedStyel,
  });

  final VoidCallback onTapGen;
  final VoidCallback? onDeleteImage;
  final Figure? role;
  final bool isVideo;
  final Function(String text) onInputTextFinish;
  final List<GenStyles> styles;
  final Function(GenStyles? style) onChooseStyles;
  final String? imagePath;
  final bool undressRole;
  final GenStyles? selectedStyel;

  @override
  State<VC2> createState() => _VC2State();
}

class _VC2State extends State<VC2> {
  GenStyles? style;
  String? customPrompt;

  @override
  void initState() {
    style = widget.selectedStyel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imgW = MediaQuery.sizeOf(context).width - 100;
    final imgH = imgW / 3 * 4;

    bool hasCustomPrompt = customPrompt != null && customPrompt!.isNotEmpty;
    var avatar = widget.role?.avatar;

    var imagePath = widget.imagePath;

    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      color: Colors.white,
                      height: imgH,
                      width: imgW,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          if (widget.undressRole && avatar != null)
                            Positioned.fill(
                              child: VImage(
                                url: avatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (imagePath != null && imagePath.isNotEmpty)
                            Positioned.fill(
                              child: Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: VCCloseBtn(
                              onTap: widget.onDeleteImage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.isVideo == false) ...[
                  VCStyle(
                    selectedStyel: style,
                    list: widget.styles,
                    onChooseed: onChooseedStyle,
                  ),
                  const SizedBox(height: 20),
                ],
                VcPrompt(
                  onTap: onTapInput,
                  isVideo: widget.isVideo,
                  customPrompt: customPrompt,
                ),
                const SizedBox(height: 140),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: VCBottom(
            onTap: widget.onTapGen,
            isVideo: widget.isVideo,
          ),
        ),
      ],
    );
  }

  void onTapInput() {
    Get.bottomSheet(
      EditScreen(
        content: customPrompt,
        onInputTextFinish: (v) {
          customPrompt = v;

          style = v.isEmpty ? widget.styles.firstOrNull : null;
          widget.onChooseStyles(style);

          widget.onInputTextFinish(v);
          setState(() {});
          Get.back();
        },
        subtitle: const Row(
          spacing: 4,
          children: [
            Text(
              "Custom Prompt:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      enableDrag: false, // 禁用底部表单拖拽，避免与文本选择冲突
      isScrollControlled: true,
      isDismissible: true,
      ignoreSafeArea: false,
    );
  }

  void onChooseedStyle(GenStyles data) {
    style = data;
    customPrompt = null;
    widget.onChooseStyles(data);
    widget.onInputTextFinish('');
    setState(() {});
  }
}
