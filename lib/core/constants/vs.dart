import 'dart:ui';

class VS {
  VS._();

  // 本地存储键名
  static const String keyUserInfo = 'KEYSEC8C16';
  static const String keyThemeMode = 'SECSAFE6D28';
  static const String keyLanguage = 'SKKEY9E415';

  // 安全存储键名（FlutterSecureStorage）
  /// 设备ID
  static const String keyDeviceId = 'SK202405A8';

  // SharedPreferences 键名
  /// CLK状态
  static const String keyClkStatus = 'SECKEY7B39';

  /// 应用重启标识
  static const String keyAppRestart = 'STOR09F215';

  /// 聊天背景图片路径
  static const String keyChatBgPath = 'KEYSAFE6D7';

  /// 用户信息（JSON）
  static const String keyUserData = 'SKEY20C419';

  /// 发送消息计数
  static const String keySendMsgCount = 'SAFE08E327';

  /// 评分计数
  static const String keyRateCount = 'STORKEY5F9';

  /// 语言设置
  static const String keyLocale = 'SKSEC3D612';

  /// 翻译对话框显示标识
  static const String keyTranslationDialog = 'KEYSTOR8A4';

  /// 安装时间戳
  static const String keyInstallTime = 'SEC20247G6';

  /// 上次奖励日期
  static const String keyLastRewardDate = 'SECSTOR9H2';

  /// 首次点击聊天输入框标识
  static const String keyFirstClickInput = 'SKSAFE4E73';

  /// 翻译消息ID列表
  static const String keyTranslationMsgIds = 'KEYSEC8C16';

  /// 登录奖励对话框标签
  static const String loginRewardTag = 'KSEC7B51L6W349';

  /// 评分对话框标签
  static const String rateUsTag = 'KYR9E34N7Z825';

  /// 充值成功对话框标签
  static const String rechargeSuccTag = 'STOR9E61A2P573';

  /// 聊天等级升级对话框标签
  static const String chatLevelUpTag = 'SAFE6C49G3R728';

  /// app言列表
  static const String appLangs = 'STOR9H53E2V7M642';

  /// 从appLangs匹配用户语言
  static Iterable<Locale> supportedLocales = const [
    Locale('en', 'US'), // 英语（美国）
    Locale('ar', 'SA'), // 阿拉伯语（沙特阿拉伯）
    Locale('fr', 'FR'), // 法语（法国）
    Locale('de', 'DE'), // 德语（德国）
    Locale('es', 'ES'), // 西班牙语（西班牙）
    Locale('pt', 'BR'), // 葡萄牙语（巴西）
    Locale('pt', 'PT'), // 葡萄牙语（葡萄牙）
    Locale('ja', 'JP'), // 日语（日本）
    Locale('ko', 'KR'), // 韩语（韩国）
    Locale('it', 'IT'), // 意大利语（意大利）
    Locale('tr', 'TR'), // 土耳其语（土耳其）
    Locale('vi', 'VN'), // 越南语（越南）
    Locale('id', 'ID'), // 印尼语（印度尼西亚）
    Locale('th', 'TH'), // 泰语（泰国）
    Locale('fil', 'PH'), // 菲律宾语（菲律宾）
    Locale('zh', 'TW'), // 繁体中文（台湾）
  ];

  // 分页相关
  static const int defaultPageSize = 10;
}
