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
    convId: json['mmxvyn'],
    msgId: json['owqiia'],
    answer: json['kmjhfp'] == null
        ? null
        : MessageAnswer.fromJson(json['kmjhfp']),
  );

  Map<String, dynamic> toJson() => {
    'mmxvyn': convId,
    'owqiia': msgId,
    'kmjhfp': answer?.toJson(),
  };
}
