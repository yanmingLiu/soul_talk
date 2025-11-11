import 'dart:convert';

class Level {
  final int? id;
  final int? level;
  final int? reward;
  final String? title;

  Level({this.id, this.level, this.reward, this.title});

  factory Level.fromRawJson(String str) => Level.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Level.fromJson(Map<String, dynamic> json) => Level(
    id: json['id'],
    level: json['level'],
    reward: json['reward'],
    title: json['title'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'level': level,
    'reward': reward,
    'title': title,
  };
}
