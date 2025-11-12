import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';
import 'package:soul_talk/router/nav_to.dart';

class MsgTransUtils {
  static final MsgTransUtils _instance = MsgTransUtils._internal();

  MsgTransUtils._internal();

  static MsgTransUtils get instance => _instance;

  int _clickCount = 0; // 点击次数
  DateTime? _firstClickTime; // 第一次点击的时间

  bool shouldShowDialog() {
    final now = DateTime.now();

    if (_firstClickTime == null ||
        now.difference(_firstClickTime!).inMinutes > 1) {
      // 超过1分钟，重置计数器
      _firstClickTime = now;
      _clickCount = 1;
      return false;
    }

    _clickCount += 1;

    if (_clickCount >= 3) {
      _clickCount = 0; // 重置计数
      return true;
    }

    return false;
  }

  Future<void> handleTranslationClick() async {
    final hasShownDialog = DI.storage.hasShownTranslationDialog;

    if (shouldShowDialog() && !hasShownDialog && !DI.login.vipStatus.value) {
      // 弹出提示弹窗
      showTranslationDialog();

      DI.storage.setShownTranslationDialog(true);
    }
  }

  void showTranslationDialog() {
    VDialog.alert(
      message: 'Automatic Translation',
      confirmText: 'Confirm',
      onConfirm: () {
        SmartDialog.dismiss();
        toVip();
      },
    );
  }

  void toVip() {
    NTO.pushVip(VipSF.trans);
  }
}
