import 'dart:convert';

class FigureMedia {
  List<String>? characterImages;

  FigureMedia({this.characterImages});

  FigureMedia copyWith({List<String>? characterImages}) =>
      FigureMedia(characterImages: characterImages ?? this.characterImages);

  factory FigureMedia.fromRawJson(String str) =>
      FigureMedia.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FigureMedia.fromJson(Map<String, dynamic> json) => FigureMedia(
    characterImages: json["character_images"] == null
        ? []
        : List<String>.from(json["character_images"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "character_images": characterImages == null
        ? []
        : List<dynamic>.from(characterImages!.map((x) => x)),
  };
}
