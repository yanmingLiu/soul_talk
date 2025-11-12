import 'package:soul_talk/domain/entities/a_level.dart';
import 'package:soul_talk/domain/entities/figure.dart';
import 'package:soul_talk/domain/entities/level.dart';
import 'package:soul_talk/domain/entities/msg_replay.dart';
import 'package:soul_talk/domain/entities/page_model.dart';

import '../constants/api_values.dart';
import '../../domain/entities/base_model.dart';
import '../../domain/entities/coversation.dart';
import '../../domain/entities/message.dart';
import 'api.dart';

class MsgApi {
  MsgApi._();

  /// 发送消息
  static Future<BaseModel<Message>?> sendMsg({
    required String path,
    Map<String, Object>? body,
  }) async {
    try {
      var result = await api.post(path, data: body);
      var res = BaseModel.fromJson(result.data, (x) => Message.fromJson(x));
      return res;
    } catch (e) {
      return null;
    }
  }

  /// 编辑消息
  static Future<Message?> editMsg({
    required String id,
    required String text,
  }) async {
    try {
      var result = await api.post(
        ApiConstants.editMsg,
        data: {'id': id, 'answer': text},
      );
      var res = BaseModel.fromJson(
        result.data,
        (json) => Message.fromJson(json),
      );
      return res.data;
    } catch (e) {
      return null;
    }
  }

  /// 修改聊天场景
  static Future<bool> editScene({
    required int convId,
    required String scene,
    required String roleId,
  }) async {
    try {
      var result = await api.post(
        ApiConstants.editScene,
        data: {
          'conversation_id': convId,
          'character_id': roleId,
          'scene': scene,
        },
      );
      var res = BaseModel.fromJson(result.data, null);
      return res.data == null ? false : true;
    } catch (e) {
      return false;
    }
  }

  /// 修改会话模式
  static Future<bool> editChatMode({
    required int convId,
    required String mode,
  }) async {
    try {
      var result = await api.post(
        ApiConstants.editMode,
        data: {'id': convId, 'chat_model': mode},
      );
      var res = BaseModel.fromJson(result.data, null);
      return res.data;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveMsgTrans({
    required String id,
    required String text,
  }) async {
    try {
      var result = await api.post(
        ApiConstants.saveMsg,
        data: {'translate_answer': text, 'id': id},
      );
      return result.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<AnserLevel?> fetchChatLevel({
    required String charId,
    required String userId,
  }) async {
    try {
      var qb = Api.queryParameters;
      qb['charId'] = charId;
      qb['userId'] = userId;

      var result = await api.post(ApiConstants.chatLevel, queryParameters: qb);
      var res = BaseModel.fromJson(
        result.data,
        (json) => AnserLevel.fromJson(json),
      );
      return res.data;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Conversation>?> sessionList(int page, int size) async {
    try {
      var res = await api.post(
        ApiConstants.sessionList,
        data: {'page': page, 'size': size},
        queryParameters: Api.queryParameters,
      );
      final data = PageModel.fromJson(
        res.data,
        (json) => Conversation.fromJson(json),
      );
      return data.records;
    } catch (e) {
      return null;
    }
  }

  static Future<Conversation?> addSession(String charId) async {
    try {
      var res = await api.post(
        ApiConstants.addSession,
        queryParameters: {'charId': charId},
      );
      return Conversation.fromJson(res.data);
    } catch (e) {
      return null;
    }
  }

  static Future<Conversation?> resetSession(int id) async {
    try {
      var res = await api.post(
        ApiConstants.resetSession,
        queryParameters: {'conversationId': id.toString()},
      );
      return Conversation.fromJson(res.data);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteSession(int id) async {
    try {
      var res = await api.post(
        ApiConstants.deleteSession,
        queryParameters: {'id': id.toString()},
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Figure>?> likedList(int page, int size) async {
    try {
      var res = await api.post(
        ApiConstants.collectList,
        data: {'page': page, 'size': size},
        queryParameters: Api.queryParameters,
      );
      final data = PageModel.fromJson(
        res.data,
        (json) => Figure.fromJson(json),
      );
      return data.records;
    } catch (e) {
      return null;
    }
  }

  // 消息列表
  static Future<List<Message>?> messageList(
    int page,
    int size,
    int convId,
  ) async {
    try {
      var res = await api.post(
        ApiConstants.messageList,
        data: {'page': page, 'size': size, 'conversation_id': convId},
        queryParameters: Api.queryParameters,
      );
      final data = PageModel.fromJson(
        res.data,
        (json) => Message.fromJson(json),
      );
      return data.records;
    } catch (e) {
      return null;
    }
  }

  static Future<MessageReplay?> sendVoiceChatMsg({
    required String roleId,
    required String userId,
    required String nickName,
    required String message,
    String? msgId,
  }) async {
    try {
      var res = await api.post(
        ApiConstants.voiceChat,
        data: {
          'char_id': roleId,
          'user_id': userId,
          'nick_name': nickName,
          'message': message,
          if (msgId?.isNotEmpty == true) 'msg_id': msgId,
        },
        queryParameters: Api.queryParameters,
      );
      return MessageReplay.fromJson(res.data);
    } catch (e) {
      return null;
    }
  }

  static Future<List<Level>?> getChatLevelConfig() async {
    try {
      var result = await api.get(ApiConstants.chatLevelConfig);
      final list = result.data;
      if (list is List) {
        final datas = list.map((x) => Level.fromJson(x)).toList();
        return datas;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> unlockImageReq(int imageId, String modelId) async {
    try {
      var result = await api.post(
        ApiConstants.unlockImage,
        data: {'image_id': imageId, 'model_id': modelId},
      );

      return result.data;
    } catch (e) {
      return false;
    }
  }
}
