import 'dart:convert';

class Price {
  final int? sceneChange;
  final int? textMessage;
  final int? audioMessage;
  final int? photoMessage;
  final int? videoMessage;
  final int? generateImage;
  final int? generateVideo;
  final int? profileChange;
  final int? callAiCharacters;

  Price({
    this.sceneChange,
    this.textMessage,
    this.audioMessage,
    this.photoMessage,
    this.videoMessage,
    this.generateImage,
    this.generateVideo,
    this.profileChange,
    this.callAiCharacters,
  });

  factory Price.fromRawJson(String str) => Price.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    sceneChange: json["ohvazp"],
    textMessage: json["gtxeuf"],
    audioMessage: json["ryxwwx"],
    photoMessage: json["upzmko"],
    videoMessage: json["axtqtf"],
    generateImage: json["cofdjq"],
    generateVideo: json["deneih"],
    profileChange: json["rvsgtm"],
    callAiCharacters: json["rmzxft"],
  );

  Map<String, dynamic> toJson() => {
    "ohvazp": sceneChange,
    "gtxeuf": textMessage,
    "ryxwwx": audioMessage,
    "upzmko": photoMessage,
    "axtqtf": videoMessage,
    "cofdjq": generateImage,
    "deneih": generateVideo,
    "rvsgtm": profileChange,
    "rmzxft": callAiCharacters,
  };
}
