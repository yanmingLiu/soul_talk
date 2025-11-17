import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/core/analytics/analytics_service.dart';
import 'package:soul_talk/core/data/gen_pi.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/domain/entities/gen_histroy.dart';
import 'package:soul_talk/domain/entities/gen_styles.dart';
import 'package:soul_talk/domain/entities/gen_upload.dart';
import 'package:soul_talk/domain/value_objects/enums.dart';
import 'package:soul_talk/presentation/ap/ec004/v/v_c_1.dart';
import 'package:soul_talk/presentation/ap/ec004/v/v_c_2.dart';
import 'package:soul_talk/presentation/ap/ec004/v/v_c_3.dart';
import 'package:soul_talk/presentation/ap/ec004/v/v_c_loading.dart';
import 'package:soul_talk/presentation/v000/loading.dart';
import 'package:soul_talk/presentation/v000/toast.dart';
import 'package:soul_talk/router/route_constants.dart';
import 'package:soul_talk/utils/file_downloader.dart';
import 'package:soul_talk/utils/image_manager.dart';

import '../../../../core/data/lo_pi.dart';

enum VCEnum { image, video, role }

enum VCStep { step1, step2, step3 }

class VC extends StatefulWidget {
  const VC({super.key, required this.type, this.role});

  final VCEnum type;
  final Figure? role;

  @override
  State<VC> createState() => _VCState();
}

class _VCState extends State<VC> {
  VCStep step = VCStep.step1;
  String imagePath = '';
  String? customPrompt;

  bool isLoading = false;
  bool undressRole = false;

  List<GenStyles> styles = [];
  GenStyles? selectedStyel;

  List<GenHistroy>? records;
  bool hasHistory = false;

  Figure? role;

  String? imageUrl;

  bool get isVideo => widget.type == VCEnum.video;

  @override
  void initState() {
    super.initState();

    role = widget.role;

    fetchStyles();
    if (widget.role != null) {
      fetchHistory();
    }
    DI.login.fetchUserInfo();
  }

  Future fetchStyles() async {
    try {
      final list = await GenApi.fetchStyleConf();
      styles.assignAll(list);
      setState(() {});
    } catch (e) {
      debugPrint('fetchStyles ❌: $e');
    }
  }

  Future fetchHistory() async {
    var characterId = role?.id;
    if (characterId == null) {
      return;
    }
    Loading.show();
    final list = await GenApi.getHistory(characterId);
    records = list;
    hasHistory = records != null && records!.isNotEmpty;
    setState(() {});
    Loading.dismiss();
  }

  void onTapUpload() async {
    var file = await ImageManager.pickImageFromGallery();
    if (file == null) return;
    imagePath = file.path;

    if (styles.isEmpty) {
      await fetchStyles();
    }
    step = VCStep.step2;
    undressRole = false;
    selectedStyel = styles.firstOrNull;
    setState(() {});
  }

  void onTapGenRole() async {
    await fetchStyles();
    if (hasHistory) {
      var res = records?.firstOrNull;
      imageUrl = res?.url;
      step = VCStep.step3;
      setState(() {});
    } else {
      final roleId = role?.id;
      if (roleId == null) return;
      undressRole = true;
      step = VCStep.step2;
      selectedStyel = styles.firstOrNull;
      setState(() {});
    }
  }

  void onTapGen() async {
    logEvent('c_un_generate');

    Loading.show();
    await DI.login.fetchUserInfo();
    Loading.dismiss();

    if (widget.type == VCEnum.video) {
      genVideo();
    } else {
      genImage();
    }
  }

  void stopLoading({bool showToast = false}) {
    isLoading = false;
    setState(() {});
    if (showToast) {
      Toast.toast("Generation failed.You can try again for free!");
    }
  }

  void genSucc() {
    DI.login.fetchUserInfo();

    step = VCStep.step3;
    logEvent('un_gen_suc');
    stopLoading();
  }

  void buySku() async {
    stopLoading();

    final from = isVideo ? ConsSF.img2v : ConsSF.aiphoto;
    Get.toNamed(RouteConstants.countSku, arguments: from);
  }

  void genImage() {
    var undressCount = DI.login.imgCreationCount.value;
    if (undressCount <= 0) {
      buySku();
      return;
    }

    if (undressRole) {
      undrRole();
    } else {
      undreImg();
    }
  }

  Future<String> getStyle() async {
    var style = '';
    if (customPrompt != null && customPrompt!.isNotEmpty) {
      String? enText = await LoginApi.translateText(customPrompt!, tlan: 'en');
      style = enText ?? '';
    } else {
      style = selectedStyel?.style ?? '';
    }
    return style;
  }

  Future undrRole() async {
    try {
      var characterId = widget.role?.id;
      if (characterId == null) return;

      setState(() {
        isLoading = true;
      });

      var style = await getStyle();
      final data = await GenApi.uploadRoleImage(
        style: style,
        characterId: characterId,
      );

      final img = data?.uid;

      if (img != null && img.contains('http')) {
        imageUrl = img;
        DI.login.fetchUserInfo();

        await Future.delayed(const Duration(seconds: 10));
        genSucc();
        fetchHistory();
        return;
      }

      final taskId = data?.uid;
      if (taskId == null) {
        stopLoading();
        return;
      }

      // 预估时间
      final estimateTime = data?.estimatedTime ?? 0;
      await Future.delayed(Duration(seconds: estimateTime));

      final result = await GenApi.getImageResult(taskId);
      var status = result?.status ?? 0;
      if (status != 2) {
        stopLoading(showToast: true);
        return;
      }

      imageUrl = result?.results?.first;

      if (imageUrl == null) {
        stopLoading(showToast: true);
        return;
      }
      genSucc();

      fetchHistory();
    } catch (e) {
      stopLoading();
    }
  }

  Future undreImg() async {
    try {
      setState(() {
        isLoading = true;
      });

      // 上传图片
      final uploadRes = await GenApi.uploadAiImage(
        imagePath: imagePath,
        style: await getStyle(),
      );
      if (uploadRes == null) {
        stopLoading(showToast: true);
        return;
      }

      final taskId = uploadRes.uid;
      if (taskId == null) {
        stopLoading(showToast: true);
        return;
      }

      if (taskId.contains('http')) {
        imageUrl = taskId;
        await Future.delayed(const Duration(seconds: 10));
        genSucc();
        return;
      }
      // 预估时间
      final estimateTime = uploadRes.estimatedTime ?? 0 + 10;
      await Future.delayed(Duration(seconds: estimateTime));

      final res = await GenApi.getImageResult(taskId);
      imageUrl = res?.results?.first;

      if (imageUrl == null) {
        stopLoading(showToast: true);
        return;
      }
      genSucc();
    } catch (e) {
      stopLoading(showToast: true);
    }
  }

  void genVideo() async {
    var undressCount = DI.login.videoCreationCount.value;
    if (undressCount <= 0) {
      buySku();
      return;
    }
    if (customPrompt == null || customPrompt!.isEmpty) {
      Toast.toast("Please enter a custom prompt");
      stopLoading();
      return;
    }

    setState(() {
      isLoading = true;
    });

    // 翻译 customPrompt：
    String? enText = await LoginApi.translateText(customPrompt!, tlan: 'en');

    // 上传图片，开始任务
    var uploadRes = await GenApi.uploadImgToVideo(
      imagePath: imagePath,
      enText: enText ?? '',
    );
    // 获取结果
    if (uploadRes == null) {
      stopLoading();
      return;
    }

    final taskId = uploadRes.uid;
    if (taskId == null) {
      stopLoading();
      return;
    }

    if (taskId.contains('http')) {
      imageUrl = taskId;
      await Future.delayed(const Duration(seconds: 10));
      genSucc();
      return;
    }

    // 预估时间
    final estimateTime = uploadRes.estimatedTime ?? 0;
    await Future.delayed(Duration(seconds: estimateTime));

    GenVideo? res = await GenApi.getVideoResult(taskId);
    var videoUrl = res?.resultPath;
    if (videoUrl == null) {
      stopLoading(showToast: true);
      return;
    }

    imageUrl = await FileDownloader.instance.downloadFile(
      videoUrl,
      fileType: FileType.video,
    );

    genSucc();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: SafeArea(top: false, child: _body())),
        if (isLoading) const VCLoading(),
      ],
    );
  }

  Widget _body() {
    if (step == VCStep.step1) {
      return VC1(
        role: widget.role,
        isVideo: isVideo,
        hasHistory: hasHistory,
        onTapGenRole: onTapGenRole,
        onTapUpload: onTapUpload,
      );
    }
    if (step == VCStep.step2) {
      return VC2(
        onTapGen: onTapGen,
        onDeleteImage: () {
          imagePath = '';
          step = VCStep.step1;
          setState(() {});
        },
        role: widget.role,
        isVideo: isVideo,
        onInputTextFinish: (String text) {
          customPrompt = text;
        },
        styles: styles,
        onChooseStyles: (value) {
          selectedStyel = value;
        },
        imagePath: imagePath,
        undressRole: undressRole,
        selectedStyel: selectedStyel,
      );
    }

    if (step == VCStep.step3) {
      return VC3(
        onTapGen: onTapUpload,
        onDeleteImage: () {
          imagePath = '';
          step = VCStep.step1;
          setState(() {});
        },
        role: widget.role,
        resultUrl: imageUrl ?? '',
        isVideo: isVideo,
      );
    }

    return Container();
  }
}
