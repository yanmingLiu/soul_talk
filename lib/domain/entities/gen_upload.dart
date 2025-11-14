import 'dart:convert';

class GenUpload {
  final int? estimatedTime;
  final String? uid;

  GenUpload({this.estimatedTime, this.uid});

  factory GenUpload.fromRawJson(String str) =>
      GenUpload.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenUpload.fromJson(Map<String, dynamic> json) =>
      GenUpload(estimatedTime: json['hmvjuo'], uid: json['zkugjr']);

  Map<String, dynamic> toJson() => {
    'hmvjuo': estimatedTime,
    'zkugjr': uid,
  };
}

class GenImageResult {
  final List<String>? results;
  final int? status;
  final String? uid;

  GenImageResult({this.results, this.status, this.uid});

  factory GenImageResult.fromRawJson(String str) =>
      GenImageResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenImageResult.fromJson(Map<String, dynamic> json) => GenImageResult(
    results: json['results'] == null
        ? []
        : List<String>.from(json['results']!.map((x) => x)),
    status: json['status'],
    uid: json['zkugjr'],
  );

  Map<String, dynamic> toJson() => {
    'results': results == null
        ? []
        : List<dynamic>.from(results!.map((x) => x)),
    'status': status,
    'zkugjr': uid,
  };
}

class GenVideoResult {
  GenVideo? item;

  GenVideoResult({this.item});

  factory GenVideoResult.fromRawJson(String str) =>
      GenVideoResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenVideoResult.fromJson(Map<String, dynamic> json) => GenVideoResult(
    item: json["item"] == null ? null : GenVideo.fromJson(json["item"]),
  );

  Map<String, dynamic> toJson() => {"item": item?.toJson()};
}

class GenVideo {
  String? uid;
  int? status;
  String? resultPath;

  GenVideo({required this.uid, required this.status, required this.resultPath});

  factory GenVideo.fromRawJson(String str) =>
      GenVideo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenVideo.fromJson(Map<String, dynamic> json) => GenVideo(
    uid: json["zkugjr"],
    status: json["status"],
    resultPath: json["ssdwpi"],
  );

  Map<String, dynamic> toJson() => {
    "zkugjr": uid,
    "status": status,
    "ssdwpi": resultPath,
  };
}
