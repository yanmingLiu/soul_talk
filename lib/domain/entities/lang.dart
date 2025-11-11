import 'dart:convert';

class Lang {
  String? label;
  String? value;

  Lang({this.label, this.value});

  Lang copyWith({String? label, String? value}) =>
      Lang(label: label ?? this.label, value: value ?? this.value);

  factory Lang.fromRawJson(String str) => Lang.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Lang.fromJson(Map<String, dynamic> json) =>
      Lang(label: json["label"], value: json["value"]);

  Map<String, dynamic> toJson() => {"label": label, "value": value};
}
