import 'package:flutter/material.dart';
import 'package:soul_talk/domain/entities/message.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/cc002/image_item.dart';
import 'package:soul_talk/presentation/ap/cc002/v_audio.dart';
import 'package:soul_talk/presentation/ap/cc002/v_text.dart';
import 'package:soul_talk/presentation/ap/cc002/v_tips.dart';
import 'package:soul_talk/presentation/ap/cc002/v_video.dart';

class MessageContainerFactory {
  MessageContainerFactory._();

  static final Map<MsgType, Widget Function(Message)> _containerBuilders = {
    MsgType.tips: (msg) => VTips(msg: msg),
    MsgType.maskTips: (msg) => VTips(msg: msg),
    MsgType.error: (msg) => VTips(msg: msg),
    MsgType.welcome: (msg) => VText(msg: msg),
    MsgType.scenario: (msg) => VText(msg: msg, title: "Scenario:"),
    MsgType.intro: (msg) => VText(msg: msg, title: "Intro:"),
    MsgType.sendText: (msg) => VText(msg: msg),
    MsgType.text: (msg) => VText(msg: msg),
    MsgType.photo: (msg) => ImageItem(msg: msg),
    MsgType.clothe: (msg) => ImageItem(msg: msg),
    MsgType.video: (msg) => VVideo(msg: msg),
    MsgType.audio: (msg) => VAudio(msg: msg, key: ValueKey(msg.id)),
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
