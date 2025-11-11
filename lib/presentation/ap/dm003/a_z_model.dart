import 'package:flutter/material.dart';
import 'package:soul_talk/domain/entities/lang.dart';

class AzListContactModel {
  final String section;
  final List<String> names;
  final List<Lang>? langs; // 添加 lang 属性来保存语言数据

  AzListContactModel({required this.section, required this.names, this.langs});
}

class AzListCursorInfoModel {
  final String title;
  final Offset offset;

  AzListCursorInfoModel({required this.title, required this.offset});
}
