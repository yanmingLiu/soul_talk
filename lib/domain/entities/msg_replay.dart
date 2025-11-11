import 'dart:convert';

import 'msg_anser.dart';

class MessageReplay {
  final String? convId;
  final String? msgId;
  final MessageAnswer? answer;

  MessageReplay({this.convId, this.msgId, this.answer});

  factory MessageReplay.fromRawJson(String str) =>
      MessageReplay.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageReplay.fromJson(Map<String, dynamic> json) => MessageReplay(
    convId: json['conv_id'],
    msgId: json['msg_id'],
    answer: json['answer'] == null
        ? null
        : MessageAnswer.fromJson(json['answer']),
  );

  Map<String, dynamic> toJson() => {
    'conv_id': convId,
    'msg_id': msgId,
    'answer': answer?.toJson(),
  };
}
