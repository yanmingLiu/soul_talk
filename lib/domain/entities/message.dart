import 'dart:convert';

import '../value_objects/enums.dart';
import 'a_level.dart';

class Message {
  String? answer;
  int? atokens;
  int? audioDuration;
  String? audioUrl;
  String? characterId;
  int? conversationId;
  int? createTime;
  int? deleted;
  String? id;
  String? imgUrl;
  int? likes;
  String? mediaLock;
  String? model;
  int? modifyTime;
  String? msgId;
  String? params;
  String? platform;
  int? qtokens;
  String? question;
  int? templateId;
  String? textLock;
  String? userId;
  int? videoDuration;
  String? videoUrl;
  String? thumbLink;
  String? voiceUrl;
  int? voiceDur;
  AnserLevel? appUserChatLevel;
  bool? upgrade;
  int? rewards;
  String? translateAnswer;
  int? giftId;
  String? giftImg;
  String? src;

  bool? onAnswer;
  bool isRead = false;
  bool showTranslate = false;
  bool typewriterAnimated = false;

  MsgType _source = MsgType.text; // 用私有变量来存储 source 的值

  MsgType get source {
    if (videoUrl != null) {
      return MsgType.video;
    }
    if (imgUrl != null) {
      return MsgType.photo;
    }
    if (audioUrl != null) {
      return MsgType.audio;
    }
    return MsgType.fromSource(src) ?? _source;
  }

  set source(MsgType value) {
    _source = value;
  }

  Message({
    this.answer,
    this.atokens,
    this.audioDuration,
    this.audioUrl,
    this.characterId,
    this.conversationId,
    this.createTime,
    this.deleted,
    this.id,
    this.imgUrl,
    this.likes,
    this.mediaLock,
    this.model,
    this.modifyTime,
    this.msgId,
    this.params,
    this.platform,
    this.qtokens,
    this.question,
    this.templateId,
    this.textLock,
    this.userId,
    this.videoDuration,
    this.videoUrl,
    this.onAnswer = false,
    this.voiceUrl,
    this.voiceDur,
    this.appUserChatLevel,
    this.upgrade,
    this.rewards,
    this.translateAnswer,
    this.thumbLink,
    this.giftId,
    this.giftImg,
    this.src,
  });

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    answer: json["kmjhfp"],
    atokens: json["atokens"],
    audioDuration: json["audio_duration"],
    audioUrl: json["audio_url"],
    characterId: json["char_id"],
    conversationId: json["luqlhc"],
    createTime: json["creat_time"],
    deleted: json["deleted"],
    id: json["id"],
    imgUrl: json["img_url"],
    likes: json["like_cnt"],
    mediaLock: json["media_lock"],
    model: json["model"],
    modifyTime: json["modify_time"],
    msgId: json["msg_identifier"],
    params: json["params"],
    platform: json["platfrm"],
    qtokens: json["qtokens"],
    question: json["qhzagm"],
    templateId: json["tmpl_id"],
    textLock: json["text_lock"],
    userId: json["usr_id"],
    videoDuration: json["video_duration"],
    videoUrl: json["video_url"],
    thumbLink: json["thumb_link"] ?? json["jdobsc"],
    voiceUrl: json["voice_link"],
    voiceDur: json["voice_dur"],
    appUserChatLevel: json["znicer"] == null
        ? null
        : AnserLevel.fromJson(json["znicer"]),
    upgrade: json["ejbios"],
    rewards: json["xlvofw"],
    translateAnswer: json["ieuqhw"],
    giftId: json["gift_id"],
    giftImg: json["gift_img"],
    src: json["rpuogl"],
  );

  Map<String, dynamic> toJson() => {
    "kmjhfp": answer,
    "atokens": atokens,
    "audio_duration": audioDuration,
    "audio_url": audioUrl,
    "char_id": characterId,
    "luqlhc": conversationId,
    "creat_time": createTime,
    "deleted": deleted,
    "id": id,
    "img_url": imgUrl,
    "like_cnt": likes,
    "media_lock": mediaLock,
    "model": model,
    "modify_time": modifyTime,
    "msg_identifier": msgId,
    "params": params,
    "platfrm": platform,
    "qtokens": qtokens,
    "qhzagm": question,
    "tmpl_id": templateId,
    "text_lock": textLock,
    "usr_id": userId,
    "video_duration": videoDuration,
    "video_url": videoUrl,
    "voice_link": voiceUrl,
    "voice_dur": voiceDur,
    "znicer": appUserChatLevel?.toJson(),
    "ejbios": upgrade,
    "xlvofw": rewards,
    "ieuqhw": translateAnswer,
    "thumb_link": thumbLink,
    "gift_id": giftId,
    "gift_img": giftImg,
    "rpuogl": src,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message && other.id == id && other.source == source;
  }

  @override
  int get hashCode => id.hashCode;
}
