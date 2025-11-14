import 'package:get/get.dart';
import 'package:soul_talk/core/data/h_pi.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/domain/entities/figure_image.dart';
import 'package:soul_talk/presentation/ap/bh001/c/h_bloc.dart';
import 'package:soul_talk/presentation/ap/cc002/c/msg_bloc.dart';
import 'package:soul_talk/presentation/v000/loading.dart';
import 'package:soul_talk/presentation/v000/v_dialog.dart';
import 'package:soul_talk/utils/log_util.dart';

class ChaterCenterController extends GetxController {
  RxList images = <FigureImage>[].obs;
  late Figure role;

  var isLoading = false.obs;

  var collect = false.obs;

  final msgCtr = Get.find<MsgBloc>();

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;
    if (arguments != null && arguments is Figure) {
      role = arguments;
    }

    images.value = role.images ?? [];

    collect.value = role.collect ?? false;

    ever(msgCtr.roleImagesChaned, (_) {
      images.value = msgCtr.role.images ?? [];
    });
  }

  void deleteChat() async {
    VDialog.alert(
      // message: LocaleKeys.delete_chat_confirmation.tr,
      // cancelText: LocaleKeys.cancel.tr,
      message: 'deleteChatConfirmation',
      onConfirm: () async {
        VDialog.dismiss();
        var res = await msgCtr.deleteConv();
        if (res) {
          Get.until((route) => route.isFirst);
        }
      },
    );
  }

  void clearHistory() async {
    VDialog.alert(
      message: "Are you sure to clear all history messages?",
      onConfirm: () async {
        VDialog.dismiss();
        await msgCtr.resetConv();
      },
    );
  }

  Future<void> onCollect() async {
    final id = role.id;
    if (id == null) {
      return;
    }
    if (isLoading.value) {
      return;
    }

    Loading.show();

    if (collect.value) {
      final res = await HomeApi.cancelCollectRole(id);
      if (res) {
        role.collect = false;
        collect.value = false;

        try {
          Get.find<HomeBloc>().followEvent.value = (
            FollowEvent.unfollow,
            id,
            DateTime.now().millisecondsSinceEpoch,
          );
        } catch (e) {
          log.e(e);
        }
      }
      isLoading.value = false;
    } else {
      final res = await HomeApi.collectRole(id);
      if (res) {
        role.collect = true;
        collect.value = true;

        try {
          Get.find<HomeBloc>().followEvent.value = (
            FollowEvent.follow,
            id,
            DateTime.now().millisecondsSinceEpoch,
          );
        } catch (e) {
          log.e(e);
        }

        if (VDialog.rateCollectShowd == false) {
          VDialog.showRateUs(
            "Hey, thanks for your likes! If you think we did a good job, please give us a good review to help us do better~ 😊",
          );
          VDialog.rateCollectShowd = true;
        }
      }
      isLoading.value = false;
    }

    Loading.dismiss();
  }
}
