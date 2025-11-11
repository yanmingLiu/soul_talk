import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:soul_talk/core/constants/api_values.dart';
import 'package:soul_talk/domain/entities/gen_upload.dart';

import '../domain/entities/base_model.dart';
import '../domain/entities/gen_histroy.dart';
import '../domain/entities/gen_styles.dart';
import '../presentation/v000/loading.dart';
import '../utils/image_manager.dart';
import 'api.dart';

class GenApi {
  GenApi._();

  /// 获取风格配置
  static Future<List<GenStyles>> fetchStyleConf() async {
    final resp = await api.post(ApiConstants.styleConf);
    final data = BaseModel.fromJson(resp.data, null);
    final list = data.data;
    return list == null
        ? []
        : (list as List).map((e) {
            return GenStyles.fromJson(e);
          }).toList();
  }

  /// ai生成图片历史
  static Future<List<GenHistroy>?> getHistory(String characterId) async {
    try {
      const path = ApiConstants.aiGetHistroy;
      final baseRes = await api.post(path, data: {"character_id": characterId});
      final resp = baseRes.data["records"];
      return resp == null
          ? []
          : (resp as List).map((e) {
              return GenHistroy.fromJson(e);
            }).toList();
    } catch (e) {
      Loading.dismiss();
      return null;
    }
  }

  /// 上传图片, ai 图片
  /// 角色
  static Future<GenUpload?> uploadRoleImage({
    required String style,
    required String characterId,
  }) async {
    try {
      // 上传图片
      final formData = dio.FormData.fromMap({
        'style': style,
        'characterId': characterId,
      });
      final ops = dio.Options(
        receiveTimeout: const Duration(seconds: 160),
        contentType: 'multipart/form-data',
      );

      const path = ApiConstants.upImageForAiImage;
      final response = await api.uploadFile(path, data: formData, options: ops);
      final json = response.data['data'];
      final data = GenUpload.fromJson(json);
      return data;
    } catch (e) {
      return null;
    }
  }

  static Future<GenUpload?> uploadAiImage({
    required String imagePath,
    required String style,
  }) async {
    try {
      // 选择图片
      final file = File(imagePath);

      // 压缩和转换后的文件
      final processedFile = await ImageManager.processImage(file);
      if (processedFile == null) {
        return null;
      }

      // 上传图片
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          processedFile.path,
          filename: 'img_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'style': style,
      });

      final ops = dio.Options(
        receiveTimeout: const Duration(seconds: 180),
        contentType: 'multipart/form-data',
        method: 'POST',
      );

      const path = ApiConstants.upImageForAiImage;

      var response = await api.uploadFile(path, data: formData, options: ops);
      final json = response.data['data'];
      final data = GenUpload.fromJson(json);
      return data;
    } catch (e) {
      return null;
    }
  }

  /// 获取任务结果 ai 图片
  static Future<GenImageResult?> getImageResult(
    String taskId, {
    int attempt = 0,
    int maxAttempts = 30,
  }) async {
    try {
      final res = await api.post(
        ApiConstants.aiImageResult,
        queryParameters: {'taskId': taskId},
      );
      var baseResponse = BaseModel.fromJson(res.data, null);
      final json = baseResponse.data;

      if (json == null) {
        await Future.delayed(const Duration(seconds: 15));
        return await getImageResult(
          taskId,
          attempt: attempt + 1,
          maxAttempts: maxAttempts,
        );
      } else {
        final data = GenImageResult.fromJson(json);
        if (data.status == 2) {
          return data;
        } else if (attempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: 15));
          return await getImageResult(
            taskId,
            attempt: attempt + 1,
            maxAttempts: maxAttempts,
          );
        } else {
          return null; // 达到最大递归次数后返回null
        }
      }
    } catch (e) {
      return null;
    }
  }

  /// 上传图片, ai 视频
  static Future<GenUpload?> uploadImgToVideo({
    required String imagePath,
    required String enText,
  }) async {
    try {
      // 选择图片
      final file = File(imagePath);

      /// 文件 md5
      var md5 = await ImageManager.calculateMd5(file);

      // 压缩和转换后的文件
      final processedFile = await ImageManager.processImage(file);
      if (processedFile == null) {
        return null;
      }

      // 上传图片
      final formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          processedFile.path,
          filename: 'img_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'style': enText,
        'fileMd5': md5,
      });

      final ops = dio.Options(
        receiveTimeout: const Duration(seconds: 180),
        contentType: 'multipart/form-data',
        method: 'POST',
      );

      const path = ApiConstants.upImageForAiVideo;

      final response = await api.uploadFile(path, data: formData, options: ops);
      final json = response.data['data'];
      final data = GenUpload.fromJson(json);
      return data;
    } catch (e) {
      return null;
    }
  }

  /// 获取任务结果 ai 视频
  static Future<GenVideo?> getVideoResult(
    String taskId, {
    int attempt = 0,
    int maxAttempts = 30,
  }) async {
    try {
      final res = await api.post(
        ApiConstants.aiVideoResult,
        queryParameters: {'taskId': taskId},
      );

      final json = res.data['data'];

      if (json == null) {
        await Future.delayed(const Duration(seconds: 15));
        return await getVideoResult(
          taskId,
          attempt: attempt + 1,
          maxAttempts: maxAttempts,
        );
      } else {
        final data = GenVideoResult.fromJson(json);
        final item = data.item;

        if (item != null && item.resultPath?.isNotEmpty == true) {
          return item;
        } else if (attempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: 15));
          return await getVideoResult(
            taskId,
            attempt: attempt + 1,
            maxAttempts: maxAttempts,
          );
        } else {
          return null; // 达到最大递归次数后返回null
        }
      }
    } catch (e) {
      return null;
    }
  }
}
