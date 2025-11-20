import 'dart:convert';

class Post {
  int? id;
  String? characterAvatar;
  String? characterId;
  String? characterName;
  String? cover;
  dynamic createTime;
  dynamic duration;
  bool? hideCharacter;
  bool? istop;
  String? media;
  dynamic mediaText;
  String? text;
  dynamic updateTime;
  bool? unlocked;
  int? price;

  Post({
    this.id,
    this.characterAvatar,
    this.characterId,
    this.characterName,
    this.cover,
    this.createTime,
    this.duration,
    this.hideCharacter,
    this.istop,
    this.media,
    this.mediaText,
    this.text,
    this.updateTime,
    this.unlocked,
    this.price,
  });

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        characterAvatar: json["character_avatar"],
        characterId: json["xbldvh"],
        characterName: json["osvkuj"],
        cover: json["cover"],
        createTime: json["ylmsjk"],
        duration: json["gfpnej"],
        hideCharacter: json["ojwetu"],
        istop: json["istop"],
        media: json["hdsnxb"],
        mediaText: json["media_text"],
        text: json["text"],
        updateTime: json["fdwojm"],
        unlocked: json["unlocked"],
        price: json["sxxlzd"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "character_avatar": characterAvatar,
        "xbldvh": characterId,
        "osvkuj": characterName,
        "cover": cover,
        "ylmsjk": createTime,
        "gfpnej": duration,
        "ojwetu": hideCharacter,
        "istop": istop,
        "hdsnxb": media,
        "media_text": mediaText,
        "text": text,
        "fdwojm": updateTime,
        "unlocked": unlocked,
        "sxxlzd": price,
      };
}
