import 'dart:convert';

class FigureImage {
  int? id;
  String? imageUrl;
  String? modelId;
  int? gems;
  int? imgType;
  dynamic imgRemark;
  bool? unlocked;

  FigureImage({
    this.id,
    this.imageUrl,
    this.modelId,
    this.gems,
    this.imgType,
    this.imgRemark,
    this.unlocked,
  });

  FigureImage copyWith({
    int? id,
    dynamic createTime,
    dynamic updateTime,
    String? imageUrl,
    String? modelId,
    int? gems,
    int? imgType,
    dynamic imgRemark,
    bool? unlocked,
  }) => FigureImage(
    id: id ?? this.id,
    imageUrl: imageUrl ?? this.imageUrl,
    modelId: modelId ?? this.modelId,
    gems: gems ?? this.gems,
    imgType: imgType ?? this.imgType,
    imgRemark: imgRemark ?? this.imgRemark,
    unlocked: unlocked ?? this.unlocked,
  );

  factory FigureImage.fromRawJson(String str) =>
      FigureImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FigureImage.fromJson(Map<String, dynamic> json) => FigureImage(
    id: json["id"],
    imageUrl: json["image_url"],
    modelId: json["stoggo"],
    gems: json["vnrzov"],
    imgType: json["img_type"],
    imgRemark: json["img_remark"],
    unlocked: json["unlocked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image_url": imageUrl,
    "stoggo": modelId,
    "vnrzov": gems,
    "img_type": imgType,
    "img_remark": imgRemark,
    "unlocked": unlocked,
  };
}
