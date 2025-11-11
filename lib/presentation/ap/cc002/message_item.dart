import 'package:flutter/material.dart';
import 'package:soul_talk/domain/entities/message.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/cc002/audio_item.dart';
import 'package:soul_talk/presentation/ap/cc002/image_item.dart';
import 'package:soul_talk/presentation/ap/cc002/text_item.dart';
import 'package:soul_talk/presentation/ap/cc002/tips_item.dart';
import 'package:soul_talk/presentation/ap/cc002/video_item.dart';

class MessageContainerFactory {
  MessageContainerFactory._();

  static final Map<MsgType, Widget Function(Message)> _containerBuilders = {
    MsgType.tips: (msg) => TipsItem(msg: msg),
    MsgType.maskTips: (msg) => TipsItem(msg: msg),
    MsgType.error: (msg) => TipsItem(msg: msg),
    MsgType.welcome: (msg) => TextItem(msg: msg),
    MsgType.scenario: (msg) => TextItem(msg: msg, title: "Scenario:"),
    MsgType.intro: (msg) => TextItem(msg: msg, title: "Intro:"),
    MsgType.sendText: (msg) => TextItem(msg: msg),
    MsgType.text: (msg) => TextItem(msg: msg),
    MsgType.photo: (msg) => ImageItem(msg: msg),
    MsgType.clothe: (msg) => ImageItem(msg: msg),
    MsgType.video: (msg) => VideoItem(msg: msg),
    MsgType.audio: (msg) => AudioItem(msg: msg, key: ValueKey(msg.id)),
  };

  /// 创建消息容器widget
  static Widget createContainer(MsgType source, Message msg) {
    final builder = _containerBuilders[source];
    return builder?.call(msg) ?? const SizedBox.shrink();
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.msg});

  final Message msg;

  MsgType get source => msg.source;

  @override
  Widget build(BuildContext context) {
    return MessageContainerFactory.createContainer(source, msg);
  }
}
