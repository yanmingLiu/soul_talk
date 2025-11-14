import 'dart:convert';

class Mask {
  final int? id;
  final String? userId;
  final String? profileName;
  final int? gender;
  final int? age;
  final String? description;
  final String? otherInfo;

  Mask({
    this.id,
    this.userId,
    this.profileName,
    this.gender,
    this.age,
    this.description,
    this.otherInfo,
  });

  factory Mask.fromRawJson(String str) => Mask.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Mask.fromJson(Map<String, dynamic> json) => Mask(
    id: json["id"],
    userId: json["rukhgz"],
    profileName: json["profile_name"],
    gender: json["nszsqd"],
    age: json["jsbtpo"],
    description: json["description"],
    otherInfo: json["other_info"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rukhgz": userId,
    "profile_name": profileName,
    "nszsqd": gender,
    "jsbtpo": age,
    "description": description,
    "other_info": otherInfo,
  };
}
