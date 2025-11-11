import 'dart:convert';

import 'package:soul_talk/domain/entities/figure_media.dart';

import 'figure_image.dart';
import 'figure_video.dart';

class Figure {
  String? id;
  int? age;
  String? aboutMe;
  FigureMedia? media;
  List<FigureImage>? images;
  String? avatar;
  dynamic avatarVideo;
  String? name;
  String? platform;
  String? renderStyle;
  String? likes;
  List<String>? greetings;
  List<dynamic>? greetingsVoice;
  String? sessionCount;
  bool? vip;
  int? orderNum;
  List<String>? tags;
  String? tagType;
  String? scenario;
  double? temperature;
  String? voiceId;
  String? engine;
  int? gender;
  bool? videoChat;
  List<FigureVideo>? characterVideoChat;
  List<String>? genPhotoTags;
  List<String>? genVideoTags;
  bool? genPhoto;
  bool? genVideo;
  bool? gems;
  bool? collect;
  String? lastMessage;
  String? intro;
  int? chatNum;
  int? msgNum;
  String? mode;
  int? cid;
  dynamic cardNum;
  dynamic unlockCardNum;
  dynamic price;
  int? updateTime;

  Figure({
    this.id,
    this.age,
    this.aboutMe,
    this.media,
    this.images,
    this.avatar,
    this.avatarVideo,
    this.name,
    this.platform,
    this.renderStyle,
    this.likes,
    this.greetings,
    this.greetingsVoice,
    this.sessionCount,
    this.vip,
    this.orderNum,
    this.tags,
    this.tagType,
    this.scenario,
    this.temperature,
    this.voiceId,
    this.engine,
    this.gender,
    this.videoChat,
    this.characterVideoChat,
    this.genPhotoTags,
    this.genVideoTags,
    this.genPhoto,
    this.genVideo,
    this.gems,
    this.collect,
    this.lastMessage,
    this.intro,
    this.chatNum,
    this.msgNum,
    this.mode,
    this.cid,
    this.cardNum,
    this.unlockCardNum,
    this.price,
    this.updateTime,
  });

  Figure copyWith({
    String? id,
    int? age,
    String? aboutMe,
    FigureMedia? media,
    List<FigureImage>? images,
    String? avatar,
    dynamic avatarVideo,
    String? name,
    String? platform,
    String? renderStyle,
    String? likes,
    List<String>? greetings,
    List<dynamic>? greetingsVoice,
    String? sessionCount,
    bool? vip,
    int? orderNum,
    List<String>? tags,
    String? tagType,
    String? scenario,
    double? temperature,
    String? voiceId,
    String? engine,
    int? gender,
    bool? videoChat,
    List<FigureVideo>? characterVideoChat,
    List<String>? genPhotoTags,
    List<String>? genVideoTags,
    bool? genPhoto,
    bool? genVideo,
    bool? gems,
    bool? collect,
    dynamic lastMessage,
    dynamic intro,
    dynamic changeClothing,
    dynamic changeClothes,
    dynamic updateTime,
    int? chatNum,
    int? msgNum,
    dynamic mode,
    int? cid,
    dynamic cardNum,
    dynamic unlockCardNum,
    dynamic price,
  }) => Figure(
    id: id ?? this.id,
    age: age ?? this.age,
    aboutMe: aboutMe ?? this.aboutMe,
    media: media ?? this.media,
    images: images ?? this.images,
    avatar: avatar ?? this.avatar,
    avatarVideo: avatarVideo ?? this.avatarVideo,
    name: name ?? this.name,
    platform: platform ?? this.platform,
    renderStyle: renderStyle ?? this.renderStyle,
    likes: likes ?? this.likes,
    greetings: greetings ?? this.greetings,
    greetingsVoice: greetingsVoice ?? this.greetingsVoice,
    sessionCount: sessionCount ?? this.sessionCount,
    vip: vip ?? this.vip,
    orderNum: orderNum ?? this.orderNum,
    tags: tags ?? this.tags,
    tagType: tagType ?? this.tagType,
    scenario: scenario ?? this.scenario,
    temperature: temperature ?? this.temperature,
    voiceId: voiceId ?? this.voiceId,
    engine: engine ?? this.engine,
    gender: gender ?? this.gender,
    videoChat: videoChat ?? this.videoChat,
    characterVideoChat: characterVideoChat ?? this.characterVideoChat,
    genPhotoTags: genPhotoTags ?? this.genPhotoTags,
    genVideoTags: genVideoTags ?? this.genVideoTags,
    genPhoto: genPhoto ?? this.genPhoto,
    genVideo: genVideo ?? this.genVideo,
    gems: gems ?? this.gems,
    collect: collect ?? this.collect,
    lastMessage: lastMessage ?? this.lastMessage,
    intro: intro ?? this.intro,
    chatNum: chatNum ?? this.chatNum,
    msgNum: msgNum ?? this.msgNum,
    mode: mode ?? this.mode,
    cid: cid ?? this.cid,
    cardNum: cardNum ?? this.cardNum,
    unlockCardNum: unlockCardNum ?? this.unlockCardNum,
    price: price ?? this.price,
    updateTime: updateTime ?? this.updateTime,
  );

  factory Figure.fromRawJson(String str) => Figure.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Figure.  fromJson(Map<String, dynamic> json) => Figure(
    id: json["id"],
    age: json["age"],
    aboutMe: json["about_me"],
    media: json["media"] == null ? null : FigureMedia.fromJson(json["media"]),
    images: json["images"] == null
        ? []
        : List<FigureImage>.from(
            json["images"]!.map((x) => FigureImage.fromJson(x)),
          ),
    avatar: json["avatar"],
    avatarVideo: json["avatar_video"],
    name: json["name"],
    platform: json["platform"],
    renderStyle: json["render_style"],
    likes: json["likes"],
    greetings: json["greetings"] == null
        ? []
        : List<String>.from(json["greetings"]!.map((x) => x)),
    greetingsVoice: json["greetings_voice"] == null
        ? []
        : List<dynamic>.from(json["greetings_voice"]!.map((x) => x)),
    sessionCount: json["session_count"],
    vip: json["vip"],
    orderNum: json["order_num"],
    tags: json["tags"] == null
        ? []
        : List<String>.from(json["tags"]!.map((x) => x)),
    tagType: json["tag_type"],
    scenario: json["scenario"],
    temperature: json["temperature"]?.toDouble(),
    voiceId: json["voice_id"],
    engine: json["engine"],
    gender: json["gender"],
    videoChat: json["video_chat"],
    characterVideoChat: json["character_video_chat"] == null
        ? []
        : List<FigureVideo>.from(
            json["character_video_chat"]!.map((x) => FigureVideo.fromJson(x)),
          ),
    genPhotoTags: json["gen_photo_tags"] == null
        ? []
        : List<String>.from(json["gen_photo_tags"]!.map((x) => x)),
    genVideoTags: json["gen_video_tags"] == null
        ? []
        : List<String>.from(json["gen_video_tags"]!.map((x) => x)),
    genPhoto: json["gen_photo"],
    genVideo: json["gen_video"],
    gems: json["gems"],
    collect: json["collect"],
    lastMessage: json["last_message"],
    intro: json["intro"],
    chatNum: json["chat_num"],
    msgNum: json["msg_num"],
    mode: json["mode"],
    cid: json["cid"],
    cardNum: json["card_num"],
    unlockCardNum: json["unlock_card_num"],
    price: json["price"],
    updateTime: json["update_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "age": age,
    "about_me": aboutMe,
    "media": media?.toJson(),
    "images": images == null
        ? []
        : List<dynamic>.from(images!.map((x) => x.toJson())),
    "avatar": avatar,
    "avatar_video": avatarVideo,
    "name": name,
    "platform": platform,
    "render_style": renderStyle,
    "likes": likes,
    "greetings": greetings == null
        ? []
        : List<dynamic>.from(greetings!.map((x) => x)),
    "greetings_voice": greetingsVoice == null
        ? []
        : List<dynamic>.from(greetingsVoice!.map((x) => x)),
    "session_count": sessionCount,
    "vip": vip,
    "order_num": orderNum,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "tag_type": tagType,
    "scenario": scenario,
    "temperature": temperature,
    "voice_id": voiceId,
    "engine": engine,
    "gender": gender,
    "video_chat": videoChat,
    "character_video_chat": characterVideoChat == null
        ? []
        : List<dynamic>.from(characterVideoChat!.map((x) => x.toJson())),
    "gen_photo_tags": genPhotoTags == null
        ? []
        : List<dynamic>.from(genPhotoTags!.map((x) => x)),
    "gen_video_tags": genVideoTags == null
        ? []
        : List<dynamic>.from(genVideoTags!.map((x) => x)),
    "gen_photo": genPhoto,
    "gen_video": genVideo,
    "gems": gems,
    "collect": collect,
    "last_message": lastMessage,
    "intro": intro,
    "chat_num": chatNum,
    "msg_num": msgNum,
    "mode": mode,
    "cid": cid,
    "card_num": cardNum,
    "unlock_card_num": unlockCardNum,
    "price": price,
    "update_time": updateTime,
  };
}
