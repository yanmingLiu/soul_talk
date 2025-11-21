import 'dart:io';

import 'package:flutter/material.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';
import 'package:soul_talk/utils/file_downloader.dart';
import 'package:video_player/video_player.dart';

class VC1 extends StatefulWidget {
  const VC1({
    super.key,
    this.role,
    required this.isVideo,
    this.hasHistory,
    this.onTapGenRole,
    required this.onTapUpload,
  });

  final Figure? role;
  final bool isVideo;
  final bool? hasHistory;
  final VoidCallback? onTapGenRole;
  final void Function() onTapUpload;

  @override
  State<VC1> createState() => _VC1State();
}

class _VC1State extends State<VC1> {
  VideoPlayerController? _controller;

  String? _localVideoPath;

  String imageUrl =
      'https://static.soultalkvideo.com/soultalk/415368522344cf52c8562facae81b0576a0993e64b20db4f7b8cd47a626e7c33.jpeg';

  String videoUrl =
      'https://static.soultalkvideo.com/soultalk/c993ee9171fa731fbd3d05e3d7e1d39aec8d88153aa421cd8c295242feda8315.mp4';

  @override
  void initState() {
    super.initState();

    FileDownloader.instance.downloadFile(videoUrl, fileType: FileType.video).then((localPath) {
      if (localPath != null) {
        _localVideoPath = localPath;
        if (widget.isVideo) {
          _initVideoPlayer();
        }
      }
    });

    if (widget.isVideo) {
      if (_localVideoPath != null) {
        _initVideoPlayer();
      }
    }
  }

  void _initVideoPlayer() {
    _controller = VideoPlayerController.file(File(_localVideoPath!));
    _controller?.initialize().then((_) {
      _controller?.setLooping(true);
      _controller?.play();
      setState(() {});
    });
  }

  Widget imageErrorWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_rounded,
        size: 26,
        color: Color(0xFF808080),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = !widget.isVideo
        ? "1.Two steps: Upload a photo, then click generate.\n2.No support for photos of minors.\n3.Upload a front-facing photo.\n4.Does not support multiple people photos."
        : "1.Two steps: Upload a photo, then click generate.\n2.No support for photos of minors.\n3.Upload a front-facing photo.";
    final text2 =
        !widget.isVideo ? "Undress Your Sweetheart Now !!" : "Make your photo animated (NSFW)";

    final imgW = MediaQuery.sizeOf(context).width - 100;
    final imgH = imgW / 3 * 4;

    bool hasRole = widget.role != null;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 16,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      color: Colors.white,
                      height: imgH,
                      width: imgW,
                      child: widget.isVideo
                          ? (_controller?.value.isInitialized ?? false)
                              ? AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: VideoPlayer(_controller!),
                                )
                              : imageErrorWidget()
                          : VImage(url: imageUrl),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          color: Color(0xFF595959),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          height: 1.4,
                        ),
                      ),
                      Center(
                        child: Text(
                          text2,
                          style: const TextStyle(
                            color: Color(0xFF55CFDA),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VButton(
              onTap: widget.onTapUpload,
              color: const Color(0xFF55CFDA),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: const Center(
                child: Text(
                  "Upload a photo",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (hasRole) ...[
              const SizedBox(height: 8),
              VButton(
                onTap: widget.onTapGenRole,
                color: const Color(0xFFF0F0F0),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: Text(
                    widget.hasHistory == true
                        ? "View the character's nude"
                        : "Undress the character",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ],
    );
  }
}
