import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:encrypt/encrypt.dart';

import 'log_util.dart';

class CryptoUtil {
  static void _log(String message) {
    log.d("CryptoUtil: $message");
  }

  // AES 密钥和 IV
  static final _key = Key.fromUtf8('wkdGIt1P5QeHAvrs');
  static final _iv = IV.fromUtf8('cSNnzM9schBV3Gc7');

  /// 加密（输出 Hex）
  static String encrypt(String content) {
    if (content.isEmpty) return content;
    try {
      final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(content, iv: _iv);
      return hex.encode(encrypted.bytes); // 输出十六进制
    } catch (e) {
      throw Exception("AES encrypt Error: $e");
    }
  }

  /// 解密（输入 Hex）
  static String decrypt(String encryptedHex) {
    if (encryptedHex.isEmpty) return encryptedHex;
    try {
      final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));

      // hex.decode() → List<int> → 转为 Uint8List
      final bytes = Uint8List.fromList(hex.decode(encryptedHex));

      final decrypted = encrypter.decrypt(Encrypted(bytes), iv: _iv);
      return decrypted;
    } catch (e) {
      throw Exception("AES decrypt Error: $e");
    }
  }

  // 其他方法（encryptParams、encryptUrl 等保持不变，复用之前的逻辑）
  static dynamic encryptParams(dynamic params) {
    if (params == null) return null;
    if (params is String) {
      return encrypt(params);
    } else if (params is Map) {
      var jsonString = json.encode(params);
      return encrypt(jsonString);
    } else if (params is List) {
      var jsonString = json.encode(params);
      return encrypt(jsonString);
    } else {
      return params;
    }
  }

  static String encryptUrl({
    required String originalUrl,
    String prefix = 'alpha',
  }) {
    final uri = Uri.parse(originalUrl);
    // 1. 构建原始路径 + 查询参数的完整路径用于加密
    final originalPathWithQuery =
        '${uri.path}${uri.query.isNotEmpty ? '?${uri.query}' : ''}';
    _log('原始完整路径: $originalPathWithQuery');

    // 2. 加密整个路径（包括查询参数）
    final encryptedPathContent = originalPathWithQuery.isNotEmpty
        ? encrypt(originalPathWithQuery)
        : '';
    _log('加密后路径: $encryptedPathContent');

    // 3. 构建新 URL (域名 + /alpha/加密内容)
    final newUri = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: '/$prefix/$encryptedPathContent',
    );

    return newUri.toString();
  }
}
