import 'dart:convert';

class User {
  String? id;
  String? deviceId;
  String? token;
  String? platform;
  int? gems;
  dynamic audioSwitch;
  dynamic subscriptionEnd;
  String? nickname;
  String? idfa;
  String? adid;
  String? androidId;
  String? gpsAdid;
  bool? autoTranslate;
  bool? enableAutoTranslate;
  String? sourceLanguage;
  String? targetLanguage;
  int createImg;
  int createVideo;

  User({
    this.id,
    this.deviceId,
    this.token,
    this.platform,
    this.gems,
    this.audioSwitch,
    this.subscriptionEnd,
    this.nickname,
    this.idfa,
    this.adid,
    this.androidId,
    this.gpsAdid,
    this.autoTranslate,
    this.enableAutoTranslate,
    this.sourceLanguage,
    this.targetLanguage,
    this.createImg = 0,
    this.createVideo = 0,
  });

  factory User.fromRawJson(String str) =>
      User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    deviceId: json["iupbww"],
    token: json["kumdyh"],
    platform: json["yfvxif"],
    gems: json["vnrzov"],
    audioSwitch: json["audio_switch"],
    subscriptionEnd: json["ufoqzj"],
    nickname: json["hyzxla"],
    idfa: json["kokujr"],
    adid: json["lbnqan"],
    androidId: json["android_id"],
    gpsAdid: json["gps_adid"],
    autoTranslate: json["pjahtu"],
    enableAutoTranslate: json["iueqln"],
    sourceLanguage: json["kpndrk"],
    targetLanguage: json["dqmnkt"],
    createImg: json["hijrou"] ?? 0,
    createVideo: json["ueonck"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "iupbww": deviceId,
    "kumdyh": token,
    "yfvxif": platform,
    "vnrzov": gems,
    "audio_switch": audioSwitch,
    "ufoqzj": subscriptionEnd,
    "hyzxla": nickname,
    "kokujr": idfa,
    "lbnqan": adid,
    "android_id": androidId,
    "gps_adid": gpsAdid,
    "pjahtu": autoTranslate,
    "iueqln": enableAutoTranslate,
    "kpndrk": sourceLanguage,
    "dqmnkt": targetLanguage,
    "hijrou": createImg,
    "ueonck": createVideo,
  };
}
