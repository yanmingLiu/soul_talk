import 'package:soul_talk/core/config/evn.dart';

import '../constants/api_values.dart';
import '../network/dio_client.dart';
import '../../domain/entities/base_model.dart';
import '../../domain/entities/figure.dart';
import '../../domain/entities/page_model.dart';
import '../../domain/entities/tag.dart';
import 'api.dart';

class HomeApi {
  HomeApi._();

  static Future<List<TagReponse>?> roleTagsList() async {
    try {
      var res = await api.get(
        ApiConstants.roleTag,
        queryParameters: Api.queryParameters,
      );
      if (res.data is List) {
        final list = (res.data as List)
            .map((e) => TagReponse.fromJson(e))
            .toList();
        return list;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // 获取开屏随机角色
  static Future<Figure?> splashRandomRole() async {
    try {
      var res = await api.request(
        ApiConstants.splashRandomRole,
        method: HttpMethod.get,
        queryParameters: Api.queryParameters,
      );
      var result = BaseModel.fromJson(
        res.data,
        (json) => Figure.fromJson(json),
      );
      return result.data;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Figure>?> homeList({
    required int page,
    required int size,
    String? rendStyl,
    String? name,
    bool? videoChat,
    bool? genImg,
    bool? genVideo,
    bool? dress,
    List<int>? tags,
  }) async {
    try {
      var data = {'page': page, 'size': size, 'platform': ENV.platform};
      if (rendStyl != null) {
        data['render_style'] = rendStyl;
      }
      if (videoChat != null) {
        data['video_chat'] = videoChat;
      }
      if (genImg != null) {
        data['gen_img'] = genImg;
      }
      if (genVideo != null) {
        data['gen_video'] = genVideo;
      }
      if (dress != null) {
        data['change_clothing'] = dress;
      }
      if (name != null) {
        data['name'] = name;
      }
      if (tags != null && tags.isNotEmpty) {
        data['tags'] = tags;
      }
      var res = await api.request(
        ApiConstants.roleList,
        data: data,
        method: HttpMethod.post,
        queryParameters: Api.queryParameters,
      );
      final rolePage = PageModel<Figure>.fromJson(
        res.data,
        (json) => Figure.fromJson(json),
      );
      return rolePage.records;
    } catch (e) {
      return null;
    }
  }

  static Future<Figure?> loadRoleById(String roleId) async {
    try {
      var qp = Api.queryParameters;
      qp['id'] = roleId;
      var res = await api.request(
        ApiConstants.getRoleById,
        method: HttpMethod.get,
        queryParameters: qp,
      );
      var role = Figure.fromJson(res.data);
      return role;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> collectRole(String roleId) async {
    try {
      var res = await api.request(
        ApiConstants.collectRole,
        method: HttpMethod.post,
        data: {'character_id': roleId},
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> cancelCollectRole(String roleId) async {
    try {
      var res = await api.request(
        ApiConstants.cancelCollectRole,
        method: HttpMethod.post,
        data: {'character_id': roleId},
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
