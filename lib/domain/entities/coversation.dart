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
    avatar: json["avatar"],
    userId: json["user_id"],
    title: json["title"],
    pinned: json["pinned"],
    pinnedTime: json["pinned_time"],
    characterId: json["character_id"],
    model: json["model"],
    templateId: json["template_id"],
    voiceModel: json["voice_model"],
    lastMessage: json["last_message"],
    updateTime: json["update_time"],
    createTime: json["create_time"],
    collect: json["collect"],
    mode: json["mode"],
    background: json["background"],
    cid: json["cid"],
    scene: json["scene"],
    profileId: json["profile_id"],
    chatModel: json["chat_model"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "user_id": userId,
    "title": title,
    "pinned": pinned,
    "pinned_time": pinnedTime,
    "character_id": characterId,
    "model": model,
    "template_id": templateId,
    "voice_model": voiceModel,
    "last_message": lastMessage,
    "update_time": updateTime,
    "create_time": createTime,
    "collect": collect,
    "mode": mode,
    "background": background,
    "cid": cid,
    "scene": scene,
    "profile_id": profileId,
    "chat_model": chatModel,
  };
}
