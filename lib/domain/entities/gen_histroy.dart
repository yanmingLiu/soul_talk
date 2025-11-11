import 'dart:convert';

class GenHistroy {
  final int? id;
  final String? url;

  GenHistroy({this.id, this.url});

  factory GenHistroy.fromRawJson(String str) =>
      GenHistroy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenHistroy.fromJson(Map<String, dynamic> json) =>
      GenHistroy(id: json['id'], url: json['url']);

  Map<String, dynamic> toJson() => {'id': id, 'url': url};
}
