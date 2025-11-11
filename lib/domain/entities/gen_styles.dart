import 'dart:convert';

class GenStyles {
  final String? name;
  final String? style;
  final String? icon;

  GenStyles({this.name, this.style, this.icon});

  factory GenStyles.fromRawJson(String str) =>
      GenStyles.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenStyles.fromJson(Map<String, dynamic> json) =>
      GenStyles(name: json["name"], style: json["style"], icon: json["icon"]);

  Map<String, dynamic> toJson() => {"name": name, "style": style, "icon": icon};
}
