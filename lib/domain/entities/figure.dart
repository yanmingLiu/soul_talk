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
    age: json["jsbtpo"],
    aboutMe: json["nsyzwq"],
    media: json["hdsnxb"] == null ? null : FigureMedia.fromJson(json["hdsnxb"]),
    images: json["images"] == null
        ? []
        : List<FigureImage>.from(
            json["images"]!.map((x) => FigureImage.fromJson(x)),
          ),
    avatar: json["vqoifz"],
    avatarVideo: json["avatar_video"],
    name: json["jgxtbn"],
    platform: json["yfvxif"],
    renderStyle: json["yqkfgr"],
    likes: json["kraode"],
    greetings: json["lvszjf"] == null
        ? []
        : List<String>.from(json["lvszjf"]!.map((x) => x)),
    greetingsVoice: json["hfrbkv"] == null
        ? []
        : List<dynamic>.from(json["hfrbkv"]!.map((x) => x)),
    sessionCount: json["ssjrnx"],
    vip: json["qfsgdo"],
    orderNum: json["bajhvg"],
    tags: json["turgnb"] == null
        ? []
        : List<String>.from(json["turgnb"]!.map((x) => x)),
    tagType: json["tag_type"],
    scenario: json["scenario"],
    temperature: json["temperature"]?.toDouble(),
    voiceId: json["bymrge"],
    engine: json["qvkkhh"],
    gender: json["nszsqd"],
    videoChat: json["grxlno"],
    characterVideoChat: json["kaemhv"] == null
        ? []
        : List<FigureVideo>.from(
            json["kaemhv"]!.map((x) => FigureVideo.fromJson(x)),
          ),
    genPhotoTags: json["lvyeja"] == null
        ? []
        : List<String>.from(json["lvyeja"]!.map((x) => x)),
    genVideoTags: json["gen_video_tags"] == null
        ? []
        : List<String>.from(json["gen_video_tags"]!.map((x) => x)),
    genPhoto: json["iwptry"],
    genVideo: json["ibrklo"],
    gems: json["vnrzov"],
    collect: json["collect"],
    lastMessage: json["tfehuw"],
    intro: json["intro"],
    chatNum: json["chat_num"],
    msgNum: json["msg_num"],
    mode: json["mode"],
    cid: json["ajhxtl"],
    cardNum: json["ynewls"],
    unlockCardNum: json["qpfisp"],
    price: json["sxxlzd"],
    updateTime: json["fdwojm"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "jsbtpo": age,
    "nsyzwq": aboutMe,
    "hdsnxb": media?.toJson(),
    "images": images == null
        ? []
        : List<dynamic>.from(images!.map((x) => x.toJson())),
    "vqoifz": avatar,
    "avatar_video": avatarVideo,
    "jgxtbn": name,
    "yfvxif": platform,
    "yqkfgr": renderStyle,
    "kraode": likes,
    "lvszjf": greetings == null
        ? []
        : List<dynamic>.from(greetings!.map((x) => x)),
    "hfrbkv": greetingsVoice == null
        ? []
        : List<dynamic>.from(greetingsVoice!.map((x) => x)),
    "ssjrnx": sessionCount,
    "qfsgdo": vip,
    "bajhvg": orderNum,
    "turgnb": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "tag_type": tagType,
    "scenario": scenario,
    "temperature": temperature,
    "bymrge": voiceId,
    "qvkkhh": engine,
    "nszsqd": gender,
    "grxlno": videoChat,
    "kaemhv": characterVideoChat == null
        ? []
        : List<dynamic>.from(characterVideoChat!.map((x) => x.toJson())),
    "lvyeja": genPhotoTags == null
        ? []
        : List<dynamic>.from(genPhotoTags!.map((x) => x)),
    "gen_video_tags": genVideoTags == null
        ? []
        : List<dynamic>.from(genVideoTags!.map((x) => x)),
    "iwptry": genPhoto,
    "ibrklo": genVideo,
    "vnrzov": gems,
    "collect": collect,
    "tfehuw": lastMessage,
    "intro": intro,
    "chat_num": chatNum,
    "msg_num": msgNum,
    "mode": mode,
    "ajhxtl": cid,
    "ynewls": cardNum,
    "qpfisp": unlockCardNum,
    "sxxlzd": price,
    "fdwojm": updateTime,
  };
}
