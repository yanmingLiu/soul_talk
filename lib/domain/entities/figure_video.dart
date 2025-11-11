import 'dart:convert';

class FigureVideo {
  int? id;
  String? characterId;
  String? tag;
  int? duration;
  String? url;
  String? gifUrl;
  dynamic createTime;
  dynamic updateTime;

  FigureVideo({
    this.id,
    this.characterId,
    this.tag,
    this.duration,
    this.url,
    this.gifUrl,
    this.createTime,
    this.updateTime,
  });

  FigureVideo copyWith({
    int? id,
    String? characterId,
    String? tag,
    int? duration,
    String? url,
    String? gifUrl,
    dynamic createTime,
    dynamic updateTime,
  }) => FigureVideo(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    tag: tag ?? this.tag,
    duration: duration ?? this.duration,
    url: url ?? this.url,
    gifUrl: gifUrl ?? this.gifUrl,
    createTime: createTime ?? this.createTime,
    updateTime: updateTime ?? this.updateTime,
  );

  factory FigureVideo.fromRawJson(String str) =>
      FigureVideo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FigureVideo.fromJson(Map<String, dynamic> json) =>
      FigureVideo(
        id: json["id"],
        characterId: json["character_id"],
        tag: json["tag"],
        duration: json["duration"],
        url: json["url"],
        gifUrl: json["gif_url"],
        createTime: json["create_time"],
        updateTime: json["update_time"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "character_id": characterId,
    "tag": tag,
    "duration": duration,
    "url": url,
    "gif_url": gifUrl,
    "create_time": createTime,
    "update_time": updateTime,
  };
}
