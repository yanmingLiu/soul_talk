import 'dart:convert';

class TagReponse {
  final String? labelType;
  final List<Tag>? tags;

  TagReponse({this.labelType, this.tags});

  factory TagReponse.fromRawJson(String str) =>
      TagReponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TagReponse.fromJson(Map<String, dynamic> json) => TagReponse(
    labelType: json["label_type"],
    tags: json["tags"] == null
        ? []
        : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "label_type": labelType,
    "tags": tags == null
        ? []
        : List<dynamic>.from(tags!.map((x) => x.toJson())),
  };
}

class Tag {
  final int? id;
  final String? name;
  String? labelType;
  bool? remark;

  Tag({this.id, this.name, this.labelType, this.remark});

  factory Tag.fromRawJson(String str) => Tag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(id: json["id"], name: json["name"], labelType: json["label_type"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "label_type": labelType,
  };
}
