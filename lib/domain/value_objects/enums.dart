import 'dart:ui';

import '../../app/di_depency.dart';

enum MsgType {
  text('TEXT_GEN'),
  video('VIDEO'),
  audio('AUDIO'),
  photo('PHOTO'),
  gift('GIFT'),
  clothe('CLOTHE'),

  sendText('sendText'),
  waitAnswer('waitAnswer'),
  tips('tips'),
  scenario('scenario'),
  intro('intro'),
  welcome('welcome'),
  maskTips('maskTips'),
  error('error');

  final String value;
  const MsgType(this.value);

  static final Map<String, MsgType> _map = {
    for (var e in MsgType.values) e.value: e,
  };

  static MsgType? fromSource(String? source) => _map[source];
}

enum VipSF {
  locktext,
  lockpic,
  lockvideo,
  lockaudio,
  send,
  homevip,
  mevip,
  chatvip,
  launch,
  relaunch,
  viprole,
  call,
  acceptcall,
  creimg,
  crevideo,
  undrphoto,
  postpic,
  postvideo,
  undrchar,
  videochat,
  trans,
  dailyrd,
  scenario,
}

enum ConsSF {
  home,
  chat,
  send,
  profile,
  text,
  audio,
  call,
  unlcokText,
  undr,
  creaimg,
  creavideo,
  album,
  aiphoto,
  img2v,
  mask,
  me,
}

extension GlobFromExt on ConsSF {
  int get gems {
    switch (this) {
      case ConsSF.text:
        return DI.login.configPrice?.textMessage ?? 2;

      case ConsSF.call:
        return DI.login.configPrice?.callAiCharacters ?? 10;
      default:
        return 0;
    }
  }
}

enum MsgLock {
  normal,
  private;

  String get value => name.toUpperCase();
}

enum ClothingState { init, chooseImage, generated }

enum CreateType { photo, video }

enum CallState { calling, incoming, listening, answering, answered, micOff }

enum Gender {
  male(0),
  female(1),
  nonBinary(2),
  unknown(-1);

  final int code;
  const Gender(this.code);

  static final Map<int, Gender> _codeMap = {
    for (var g in Gender.values) g.code: g,
  };

  /// 根据数值反查 Gender
  static Gender fromValue(int? code) => _codeMap[code] ?? Gender.unknown;

  String get display {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.nonBinary:
        return 'Non-Binary';
      case Gender.unknown:
        return 'unknown';
    }
  }

  String get icon {
    switch (this) {
      case Gender.male:
        return 'assets/images/male@3x.png';
      case Gender.female:
        return 'assets/images/female@3x.png';
      case Gender.nonBinary:
        return 'assets/images/non@3x.png';
      case Gender.unknown:
        return 'assets/images/non@3x.png';
    }
  }

  Color get color {
    switch (this) {
      case Gender.male:
        return const Color(0xFF85FFCD);
      case Gender.female:
        return const Color(0xFFFEB6EA);
      case Gender.nonBinary:
        return const Color(0xFFFFFF60);
      case Gender.unknown:
        return const Color(0xFF00AB8E);
    }
  }
}
