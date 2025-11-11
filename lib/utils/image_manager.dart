import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageManager {
  static final ImagePicker _picker = ImagePicker();

  /// 从相册选择图片
  ///
  /// [maxWidth] 图片最大宽度
  /// [maxHeight] 图片最大高度
  /// [imageQuality] 图片质量（0-100）
  /// 返回选择的图片文件，取消或失败时返回null
  static Future<File?> pickImageFromGallery({
    double? maxWidth,
    double? maxHeight,
    int imageQuality = 85,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (pickedFile != null) {
        debugPrint('ImageUtils.pickImageFromGallery ✅: ${pickedFile.path}');
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('ImageUtils.pickImageFromGallery ❌: $e');
      return null;
    }
  }

  /// 从相机拍照
  ///
  /// [maxWidth] 图片最大宽度
  /// [maxHeight] 图片最大高度
  /// [imageQuality] 图片质量（0-100）
  /// 返回拍摄的图片文件，取消或失败时返回null
  static Future<File?> pickImageFromCamera({
    double? maxWidth,
    double? maxHeight,
    int imageQuality = 85,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (pickedFile != null) {
        debugPrint('ImageUtils.pickImageFromCamera ✅: ${pickedFile.path}');
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('ImageUtils.pickImageFromCamera ❌: $e');
      return null;
    }
  }

  /// 从相册选择多张图片
  ///
  /// [maxWidth] 图片最大宽度
  /// [maxHeight] 图片最大高度
  /// [imageQuality] 图片质量（0-100）
  /// [limit] 最多选择的图片数量
  /// 返回选择的图片文件列表，取消或失败时返回空列表
  static Future<List<File>> pickMultipleImages({
    double? maxWidth,
    double? maxHeight,
    int imageQuality = 85,
    int? limit,
  }) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        limit: limit,
      );

      if (pickedFiles.isNotEmpty) {
        debugPrint(
          'ImageUtils.pickMultipleImages ✅: ${pickedFiles.length} images selected',
        );
        return pickedFiles.map((xFile) => File(xFile.path)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('ImageUtils.pickMultipleImages ❌: $e');
      return [];
    }
  }

  /// 裁剪图片
  ///
  /// [file] 待裁剪的图片文件
  /// [aspectRatioX] 裁剪宽高比（宽度）
  /// [aspectRatioY] 裁剪宽高比（高度）
  /// [maxWidth] 输出图片最大宽度
  /// [maxHeight] 输出图片最大高度
  /// [compressQuality] 压缩质量（0-100）
  /// 返回裁剪后的图片文件，取消或失败时返回null
  static Future<File?> cropImage(
    File file, {
    int? aspectRatioX,
    int? aspectRatioY,
    int? maxWidth,
    int? maxHeight,
    int compressQuality = 90,
  }) async {
    try {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: (aspectRatioX != null && aspectRatioY != null)
            ? CropAspectRatio(
                ratioX: aspectRatioX.toDouble(),
                ratioY: aspectRatioY.toDouble(),
              )
            : null,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        compressQuality: compressQuality,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'crop image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: aspectRatioX != null && aspectRatioY != null,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'crop image',
            aspectRatioLockEnabled:
                aspectRatioX != null && aspectRatioY != null,
            resetAspectRatioEnabled: true,
            aspectRatioPickerButtonHidden: false,
          ),
        ],
      );

      if (croppedFile != null) {
        debugPrint('ImageUtils.cropImage ✅: ${croppedFile.path}');
        return File(croppedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('ImageUtils.cropImage ❌: $e');
      return null;
    }
  }

  /// 裁剪图片（方形）
  ///
  /// [file] 待裁剪的图片文件
  /// [size] 输出图片尺寸（正方形边长）
  /// [compressQuality] 压缩质量（0-100）
  /// 返回裁剪后的图片文件，取消或失败时返回null
  static Future<File?> cropImageSquare(
    File file, {
    int? size,
    int compressQuality = 90,
  }) async {
    return cropImage(
      file,
      aspectRatioX: 1,
      aspectRatioY: 1,
      maxWidth: size,
      maxHeight: size,
      compressQuality: compressQuality,
    );
  }

  /// 处理图片：压缩并转换为 JPG 格式
  ///
  /// [file] 待处理的图片文件
  /// 返回处理后的文件，失败时返回null
  static Future<File?> processImage(File file) async {
    final compressedFile = await compressAndConvertToJpg(file);
    return compressedFile;
  }

  /// 压缩图片并转换为 JPG 格式
  ///
  /// [file] 待处理的图片文件
  /// [initialQuality] 初始压缩质量（默认85）
  /// [minSize] 目标文件大小（默认2MB）
  /// 返回压缩后的文件，失败时返回null
  static Future<File?> compressAndConvertToJpg(
    File file, {
    int initialQuality = 85,
    int minSize = 2 * 1024 * 1024,
  }) async {
    try {
      int fileSize = await file.length();

      // 如果文件已经是JPG且小于目标大小，直接返回
      if (fileSize <= minSize &&
          file.path.split('.').last.toLowerCase() == 'jpg') {
        return file;
      }

      int quality = initialQuality;
      File? compressedFile;

      do {
        // 获取临时目录
        final tempDir = await getTemporaryDirectory();
        // 创建新的文件路径
        final targetPath = join(
          tempDir.path,
          '${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        final XFile? compressedXFile =
            await FlutterImageCompress.compressAndGetFile(
              file.absolute.path,
              targetPath,
              quality: quality,
              format: CompressFormat.jpeg,
            );

        if (compressedXFile != null) {
          compressedFile = File(compressedXFile.path);
          int compressedFileSize = await compressedFile.length();

          if (compressedFileSize <= minSize) {
            return compressedFile;
          } else {
            quality -= 5; // 每次减少5的质量
            if (quality < 10) break; // 避免质量过低
          }
        } else {
          return null;
        }
      } while (quality >= 10);

      return compressedFile;
    } catch (e) {
      debugPrint('ImageUtils.compressAndConvertToJpg ❌: $e');
    }
    return null;
  }

  /// 计算文件的 MD5 哈希值
  ///
  /// [file] 待计算的文件
  /// 返回MD5哈希字符串，失败时返回空字符串
  static Future<String> calculateMd5(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return md5.convert(bytes).toString();
    } catch (e) {
      debugPrint('ImageUtils.calculateMd5 ❌: $e');
      return '';
    }
  }

  /// 判断两个文件是否相同（通过MD5比较）
  ///
  /// [file1] 第一个文件
  /// [file2] 第二个文件
  /// 返回true表示文件相同，false表示不同或计算失败
  static Future<bool> isSameImage(File file1, File file2) async {
    final hash1 = await calculateMd5(file1);
    final hash2 = await calculateMd5(file2);
    return hash1.isNotEmpty && hash1 == hash2;
  }

  /// 获取图片文件大小（字节）
  ///
  /// [file] 图片文件
  /// 返回文件大小，失败时返回0
  static Future<int> getImageFileSize(File file) async {
    try {
      return await file.length();
    } catch (e) {
      debugPrint('ImageUtils.getImageFileSize ❌: $e');
      return 0;
    }
  }

  /// 获取图片文件大小（可读格式）
  ///
  /// [file] 图片文件
  /// 返回格式化的文件大小字符串，如 "2.5 MB"
  static Future<String> getImageFileSizeFormatted(File file) async {
    final bytes = await getImageFileSize(file);
    if (bytes == 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    var size = bytes.toDouble();

    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }

    return '${size.toStringAsFixed(2)} ${suffixes[i]}';
  }

  /// 检查文件是否为图片
  ///
  /// [file] 待检查的文件
  /// 返回true表示是图片，false表示不是
  static bool isImageFile(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension);
  }

  /// 获取图片文件扩展名
  ///
  /// [file] 图片文件
  /// 返回文件扩展名（小写），如 "jpg"
  static String getImageExtension(File file) {
    return file.path.split('.').last.toLowerCase();
  }

  /// 生成唯一的临时文件名
  ///
  /// [prefix] 文件名前缀
  /// [extension] 文件扩展名
  /// 返回带时间戳的唯一文件名
  static String generateUniqueFileName({
    String prefix = 'image',
    String extension = 'jpg',
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return '${prefix}_${timestamp}_$random.$extension';
  }

  /// 批量处理图片
  ///
  /// [files] 待处理的图片文件列表
  /// [initialQuality] 初始压缩质量
  /// [minSize] 目标文件大小
  /// 返回处理后的文件列表
  static Future<List<File>> batchProcessImages(
    List<File> files, {
    int initialQuality = 85,
    int minSize = 2 * 1024 * 1024,
  }) async {
    final List<File> processedFiles = [];

    for (final file in files) {
      final processed = await compressAndConvertToJpg(
        file,
        initialQuality: initialQuality,
        minSize: minSize,
      );
      if (processed != null) {
        processedFiles.add(processed);
      }
    }

    debugPrint(
      'ImageUtils.batchProcessImages ✅: ${processedFiles.length}/${files.length} processed',
    );
    return processedFiles;
  }

  /// 验证图片文件是否有效
  ///
  /// [file] 待验证的图片文件
  /// 返回true表示有效，false表示无效
  static Future<bool> validateImageFile(File file) async {
    try {
      if (!await file.exists()) {
        debugPrint('ImageUtils.validateImageFile ❌: File does not exist');
        return false;
      }

      final size = await file.length();
      if (size == 0) {
        debugPrint('ImageUtils.validateImageFile ❌: File is empty');
        return false;
      }

      if (!isImageFile(file)) {
        debugPrint('ImageUtils.validateImageFile ❌: Not an image file');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('ImageUtils.validateImageFile ❌: $e');
      return false;
    }
  }

  /// 删除临时图片文件
  ///
  /// [file] 待删除的文件
  /// 返回true表示删除成功，false表示失败
  static Future<bool> deleteImageFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        debugPrint('ImageUtils.deleteImageFile ✅: ${file.path}');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('ImageUtils.deleteImageFile ❌: $e');
      return false;
    }
  }

  /// 批量删除图片文件
  ///
  /// [files] 待删除的文件列表
  /// 返回成功删除的文件数量
  static Future<int> batchDeleteImageFiles(List<File> files) async {
    int deletedCount = 0;

    for (final file in files) {
      if (await deleteImageFile(file)) {
        deletedCount++;
      }
    }

    debugPrint(
      'ImageUtils.batchDeleteImageFiles ✅: $deletedCount/${files.length} deleted',
    );
    return deletedCount;
  }
}
