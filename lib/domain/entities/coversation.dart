import 'dart:convert';

class Conversation {
  int? id;
  String? avatar;
  String? userId;
  String? title;
  bool? pinned;
  dynamic pinnedTime;
  String? characterId;
  dynamic model;
  int? templateId;
  String? voiceModel;
  dynamic lastMessage;
  int? updateTime;
  int? createTime;
  bool? collect;
  String? mode;
  dynamic background;
  int? cid;
  String? scene;
  int? profileId;
  String? chatModel;

  Conversation({
    this.id,
    this.avatar,
    this.userId,
    this.title,
    this.pinned,
    this.pinnedTime,
    this.characterId,
    this.model,
    this.templateId,
    this.voiceModel,
    this.lastMessage,
    this.updateTime,
    this.createTime,
    this.collect,
    this.mode,
    this.background,
    this.cid,
    this.scene,
    this.profileId,
    this.chatModel,
  });

  factory Conversation.fromRawJson(String str) =>
      Conversation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    id: json["id"],
    avatar: json["vqoifz"],
    userId: json["rukhgz"],
    title: json["title"],
    pinned: json["pinned"],
    pinnedTime: json["pinned_time"],
    characterId: json["xbldvh"],
    model: json["model"],
    templateId: json["jpocex"],
    voiceModel: json["voice_model"],
    lastMessage: json["tfehuw"],
    updateTime: json["fdwojm"],
    createTime: json["ylmsjk"],
    collect: json["collect"],
    mode: json["mode"],
    background: json["background"],
    cid: json["ajhxtl"],
    scene: json["ciuqkf"],
    profileId: json["thpnrc"],
    chatModel: json["gndxwy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vqoifz": avatar,
    "rukhgz": userId,
    "title": title,
    "pinned": pinned,
    "pinned_time": pinnedTime,
    "xbldvh": characterId,
    "model": model,
    "jpocex": templateId,
    "voice_model": voiceModel,
    "tfehuw": lastMessage,
    "fdwojm": updateTime,
    "ylmsjk": createTime,
    "collect": collect,
    "mode": mode,
    "background": background,
    "ajhxtl": cid,
    "ciuqkf": scene,
    "thpnrc": profileId,
    "gndxwy": chatModel,
  };
}
