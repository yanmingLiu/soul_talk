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
        characterId: json["xbldvh"],
        tag: json["tag"],
        duration: json["gfpnej"],
        url: json["uxpnyz"],
        gifUrl: json["gif_url"],
        createTime: json["ylmsjk"],
        updateTime: json["fdwojm"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "xbldvh": characterId,
    "tag": tag,
    "gfpnej": duration,
    "uxpnyz": url,
    "gif_url": gifUrl,
    "ylmsjk": createTime,
    "fdwojm": updateTime,
  };
}
