import 'dart:io';

import 'package:flutter/material.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/presentation/ap/ec004/v/v_c_close_btn.dart';
import 'package:soul_talk/presentation/v000/v_bottom_btn.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/router/nav_to.dart';
import 'package:video_player/video_player.dart';

class VC3 extends StatefulWidget {
  const VC3({
    super.key,
    this.role,
    required this.onTapGen,
    this.onDeleteImage,
    required this.resultUrl,
    required this.isVideo,
  });

  final Figure? role;
  final VoidCallback onTapGen;
  final VoidCallback? onDeleteImage;
  final String resultUrl;
  final bool isVideo;

  @override
  State<VC3> createState() => _VC3State();
}

class _VC3State extends State<VC3> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _controller = VideoPlayerController.file(File(widget.resultUrl))
        ..initialize().then((_) {
          _controller?.setLooping(true);
          _controller?.play();
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VC3 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVideo && widget.resultUrl != oldWidget.resultUrl) {
      _controller?.dispose();

      _controller = VideoPlayerController.file(File(widget.resultUrl))
        ..initialize().then((_) {
          _controller?.setLooping(true);
          _controller?.play();
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imgW = MediaQuery.sizeOf(context).width - 100;
    final imgH = imgW / 3 * 4;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.only(top: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.hardEdge,
            child: Container(
              color: const Color(0x1AFFFFFF),
              height: imgH,
              width: imgW,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Positioned.fill(
                    child: InkWell(
                      child: widget.isVideo
                          ? (_controller?.value.isInitialized ?? false)
                              ? AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: VideoPlayer(_controller!),
                                )
                              : const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      backgroundColor: Colors.white,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF55CFDA),
                                      ),
                                    ),
                                  ),
                                )
                          : VImage(url: widget.resultUrl),
                      onTap: () {
                        if (widget.isVideo) {
                          NTO.pushVideoPreview(widget.resultUrl);
                        } else {
                          NTO.pushImagePreview(widget.resultUrl);
                        }
                      },
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
        const Spacer(),
        VBottomBtn(onTap: widget.onTapGen, title: 'Generate another one'),
      ],
    );
  }
}
