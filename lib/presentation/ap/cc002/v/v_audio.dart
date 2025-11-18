import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/core/services/audio_player_service.dart';
import 'package:soul_talk/domain/entities/message.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/cc002/v/v_text.dart';
import 'package:soul_talk/router/nav_to.dart';

enum PlayState { downloading, playing, paused, stopped, error }

class VAudio extends StatefulWidget {
  const VAudio({super.key, required this.msg});

  final Message msg;

  @override
  State<VAudio> createState() => _VAudioState();
}

class _VAudioState extends State<VAudio> with SingleTickerProviderStateMixin {
  /// 动画控制器
  AnimationController? _controller;

  /// 全局音频管理器
  late final AudioPlayerService _audioManager;

  /// 消息ID，用作唯一标识
  late final String _msgId;

  @override
  void initState() {
    super.initState();
    _msgId = widget.msg.id.toString();
    _audioManager = DI.audio;
    _initializeAnimationController();
    _checkRestoredPlayState();
  }

  /// 检查是否需要恢复播放状态
  void _checkRestoredPlayState() {
    try {
      // 检查全局管理器中的状态
      final audioState = _audioManager.getAudioState(_msgId);
      if (audioState?.state == AudioPlayState.playing) {
        _startPlayAnimation();
      }
    } catch (e) {
      debugPrint('_checkRestoredPlayState e: $e');
    }
  }

  /// 初始化动画控制器
  void _initializeAnimationController() {
    try {
      _controller = AnimationController(vsync: this);
    } catch (e) {
      debugPrint('_initializeAnimationController e: $e');
    }
  }

  @override
  void dispose() {
    _cleanupResources();
    super.dispose();
  }

  /// 清理资源
  void _cleanupResources() {
    try {
      _controller?.dispose();
    } catch (e) {
      debugPrint('_cleanupResources e: $e');
    }
  }

  /// 构建音频UI组件 - 优化版本
  Widget _buildAudioUI() {
    return RepaintBoundary(
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        child: Lottie.asset(
          'assets/images/Audio.json',
          controller: _controller,
          fit: BoxFit.fill,
          onLoaded: (composition) {
            // 只设置动画持续时间，不控制播放
            _controller?.duration = composition.duration;
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.audiotrack,
              color: Colors.deepOrange,
              size: 24,
            );
          },
        ),
      ),
    );
  }

  /// 开始音频播放 - 使用全局管理器
  Future<void> _startAudioPlay() async {
    try {
      logEvent('c_news_voice');
      // // https://static.amorai.net/2.mp3
      await _audioManager.startPlay(_msgId, widget.msg.audioUrl);
    } catch (e) {
      debugPrint('_startAudioPlay e: $e');
    }
  }

  /// 停止音频播放 - 使用全局管理器
  Future<void> _stopAudioPlay() async {
    try {
      await _audioManager.stopPlay(_msgId);
    } catch (e) {
      debugPrint('_stopAudioPlay e: $e');
    }
  }

  Future<void> _pausedPlay() async {
    try {
      await _audioManager.pausedPlay(_msgId);
    } catch (e) {
      debugPrint('_stopAudioPlay e: $e');
    }
  }

  Future<void> _resumePlay() async {
    try {
      await _audioManager.resumePlay(_msgId);
    } catch (e) {
      debugPrint('_stopAudioPlay e: $e');
    }
  }

  /// 开始播放动画 - 根据音频状态循环播放
  void _startPlayAnimation() {
    if (!mounted) return;

    try {
      // 确保动画控制器有持续时间，并将其作为周期参数传入
      if (_controller?.duration != null) {
        _controller?.repeat(period: _controller!.duration);
      } else {
        // 如果没有设置持续时间，提供一个默认值
        const defaultDuration = Duration(seconds: 1);
        _controller?.duration = defaultDuration;
        _controller?.repeat(period: defaultDuration);
      }
    } catch (e) {
      debugPrint('_startPlayAnimation e: $e');
    }
  }

  /// 停止播放动画 - 优化版本
  void _stopPlayAnimation() {
    if (mounted) {
      _controller?.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        spacing: 8,
        children: [
          VText(msg: widget.msg),
          Row(children: [_buildAudioWidget()]),
        ],
      ),
    );
  }

  /// 构建音频组件 - 优化版本
  Widget _buildAudioWidget() {
    final isRead = widget.msg.isRead;
    final isShowTrial = !DI.login.vipStatus.value;

    return GestureDetector(
      onTap: () => _handleAudioTap(isRead),
      child: _buildAudioContainer(isShowTrial, isRead),
    );
  }

  /// 构建音频容器
  Widget _buildAudioContainer(bool isShowTrial, bool isRead) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 300,
          height: 38,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF55CFDA), Color(0x0055CFDA)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0x80000000),
            ),
            child: Row(
              spacing: 8,
              children: [
                _buildStatusIcon(),
                const Text(
                  'Moans for you',
                  style: TextStyle(
                    color: Color(0xFF55CFDA),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Expanded(
                  child: _buildAudioUI(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 处理音频点击事件 - 使用全局管理器
  void _handleAudioTap(bool isRead) {
    try {
      final currentAudioState = _audioManager.getAudioState(_msgId);
      final currentState = currentAudioState?.state ?? AudioPlayState.stopped;

      // VIP权限检查
      if (!DI.login.vipStatus.value) {
        logEvent('c_news_lockaudio');
        NTO.pushVip(VipSF.lockaudio);
        return;
      }

      // 根据当前状态决定操作
      switch (currentState) {
        case AudioPlayState.stopped:
        case AudioPlayState.error:
          _startAudioPlay();
          break;

        case AudioPlayState.playing:
          _pausedPlay();

        case AudioPlayState.paused:
          _resumePlay();

        case AudioPlayState.downloading:
          _stopAudioPlay();
          break;
      }
    } catch (e) {
      debugPrint('_handleAudioTap e: $e');
    }
  }

  /// 构建状态图标 - 使用全局管理器状态
  Widget _buildStatusIcon() {
    return Obx(() {
      final audioState = _audioManager.getAudioState(_msgId);
      final currentState = audioState?.state ?? AudioPlayState.stopped;

      // 同时监听全局播放状态变化，用于动画同步
      _audioManager.currentPlayingAudio.value;

      // 如果是当前正在播放的音频，开始动画
      if (currentState == AudioPlayState.playing &&
          _audioManager.currentPlayingAudio.value?.msgId == _msgId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _startPlayAnimation();
          }
        });
      } else if (currentState != AudioPlayState.playing) {
        // 如果不是播放状态，停止动画
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _stopPlayAnimation();
          }
        });
      }

      switch (currentState) {
        case AudioPlayState.downloading:
          return _buildLoadingIcon();
        case AudioPlayState.playing:
          return _buildPlayingIcon();
        case AudioPlayState.paused:
          return _buildPausedIcon();
        case AudioPlayState.error:
          return _buildErrorIcon();
        default:
          return _buildNormorIcon();
      }
    });
  }

  /// 构建加载图标
  Widget _buildLoadingIcon() {
    return const SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(
        color: Color(0xFF55CFDA),
        strokeWidth: 2,
        padding: EdgeInsets.all(2),
      ),
    );
  }

  Widget _buildPlayingIcon() {
    return Image.asset('assets/images/play@3x.png', width: 16);
  }

  Widget _buildPausedIcon() {
    return Image.asset('assets/images/pause@3x.png', width: 16);
  }

  Widget _buildNormorIcon() {
    return Image.asset('assets/images/normal@3x.png', width: 16);
  }

  /// 构建错误图标
  Widget _buildErrorIcon() {
    return const Icon(
      Icons.error_outline,
      color: Colors.red,
      size: 20,
      semanticLabel: 'try again',
    );
  }
}
