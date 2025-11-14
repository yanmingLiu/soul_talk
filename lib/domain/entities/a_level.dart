import 'dart:convert';

class AnserLevel {
  final int? id;
  final String? userId;
  final int? conversationId;
  final String? charId;
  final int? level;
  final double? progress;
  final double? upgradeRequirements;
  final int? rewards;

  AnserLevel({
    this.id,
    this.userId,
    this.conversationId,
    this.charId,
    this.level,
    this.progress,
    this.upgradeRequirements,
    this.rewards,
  });

  AnserLevel copyWith({
    int? id,
    String? userId,
    int? conversationId,
    String? charId,
    int? level,
    double? progress,
    double? upgradeRequirements,
    int? rewards,
  }) => AnserLevel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    conversationId: conversationId ?? this.conversationId,
    charId: charId ?? this.charId,
    level: level ?? this.level,
    progress: progress ?? this.progress,
    upgradeRequirements: upgradeRequirements ?? this.upgradeRequirements,
    rewards: rewards ?? this.rewards,
  );

  factory AnserLevel.fromRawJson(String str) =>
      AnserLevel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AnserLevel.fromJson(Map<String, dynamic> json) => AnserLevel(
    id: json['id'],
    userId: json['rukhgz'],
    conversationId: json['luqlhc'],
    charId: json['char_id'],
    level: json['level'],
    progress: json['progress'],
    upgradeRequirements: json['upgrade_requirements'],
    rewards: json['xlvofw'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'rukhgz': userId,
    'luqlhc': conversationId,
    'char_id': charId,
    'level': level,
    'progress': progress,
    'upgrade_requirements': upgradeRequirements,
    'xlvofw': rewards,
  };
}
