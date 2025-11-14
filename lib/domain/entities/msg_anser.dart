import 'dart:convert';

import 'a_level.dart';

class MessageAnswer {
  final String? content;
  final String? src;
  final String? lockLvl;
  final String? lockMed;
  final String? voiceUrl;
  final int? voiceDur;
  final String? resUrl;
  final int? duration;
  final String? thumbUrl;
  final String? translateContent;
  final bool? upgrade;
  final int? rewards;
  final AnserLevel? appUserChatLevel;

  MessageAnswer({
    this.content,
    this.src,
    this.lockLvl,
    this.lockMed,
    this.voiceUrl,
    this.voiceDur,
    this.resUrl,
    this.duration,
    this.thumbUrl,
    this.translateContent,
    this.upgrade,
    this.rewards,
    this.appUserChatLevel,
  });

  factory MessageAnswer.fromRawJson(String str) =>
      MessageAnswer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageAnswer.fromJson(Map<String, dynamic> json) => MessageAnswer(
    content: json['content'],
    src: json['rpuogl'],
    lockLvl: json['yejipp'],
    lockMed: json['osokys'],
    voiceUrl: json['qguhno'],
    voiceDur: json['qfhccc'],
    resUrl: json['res_url'],
    duration: json['gfpnej'],
    thumbUrl: json['jdobsc'],
    translateContent: json['translate_content'],
    upgrade: json['ejbios'],
    rewards: json['xlvofw'],
    appUserChatLevel: json['znicer'] == null
        ? null
        : AnserLevel.fromJson(json['znicer']),
  );

  Map<String, dynamic> toJson() => {
    'content': content,
    'rpuogl': src,
    'yejipp': lockLvl,
    'osokys': lockMed,
    'qguhno': voiceUrl,
    'qfhccc': voiceDur,
    'res_url': resUrl,
    'gfpnej': duration,
    'jdobsc': thumbUrl,
    'translate_content': translateContent,
    'ejbios': upgrade,
    'xlvofw': rewards,
    'znicer': appUserChatLevel,
  };
}
