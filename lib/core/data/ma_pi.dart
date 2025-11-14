import '../../domain/entities/base_model.dart';
import '../../domain/entities/mask.dart';
import '../../domain/entities/page_model.dart';
import '../constants/api_values.dart';
import 'api.dart';

class MaskApi {
  MaskApi._();

  /// 获取 mask 列表 分页
  static Future<List<Mask>?> getMaskList({int page = 1, int size = 10}) async {
    try {
      var result = await api.post(
        ApiConstants.getMaskList,
        data: {'page': page, 'size': size, 'user_id': Api.userId},
      );
      final res = PageModel.fromJson(
        result.data,
        (json) => Mask.fromJson(json),
      );
      return res.records;
    } catch (e) {
      return null;
    }
  }

  /// 切换 mask
  static Future<bool> changeMask({
    required int? conversationId,
    required int? maskId,
  }) async {
    try {
      var result = await api.post(
        ApiConstants.changeMask,
        data: {'conversation_id': conversationId, 'profile_id': maskId},
      );
      var res = BaseModel.fromJson(result.data, null);
      return res.data;
    } catch (e) {
      return false;
    }
  }

  /// 删除 mask
  static Future<bool> deleteMask({required int id}) async {
    try {
      var result = await api.post(ApiConstants.deleteMask, data: {'id': id});
      var res = BaseModel.fromJson(result.data, null);
      return res.data ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 新建 mask
  static Future<bool> createOrUpdateMask({
    required String name,
    required String age,
    required int gender,
    required String? description,
    required String? otherInfo,
    required int? id,
  }) async {
    try {
      final isEdit = id != null;
      final path = isEdit ? ApiConstants.editMask : ApiConstants.createMask;
      final body = <String, dynamic>{
        'profile_name': name,
        'age': age,
        'gender': gender,
        'description': description,
        'other_info': otherInfo,
        'user_id': Api.userId,
      };
      if (isEdit) {
        body['id'] = id;
      }

      var result = await api.post(path, data: body);
      var res = BaseModel.fromJson(result.data, null);
      return isEdit ? res.data : res.data != null;
    } catch (e) {
      return false;
    }
  }
}
