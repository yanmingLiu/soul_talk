// ChaterModel扩展
import '../entities/figure.dart';

const kNSFW = 'NSFW';
const kBDSM = 'BDSM';

extension FigureExt on Figure {
  /// 提取标签构建逻辑，避免build方法中重复计算
  List<String> buildDisplayTags() {
    final tags = this.tags;
    List<String> result = (tags != null && tags.length > 3)
        ? tags.take(3).toList()
        : tags ?? [];

    final tagType = this.tagType;
    if (tagType != null) {
      if (tagType.contains(kNSFW) && !result.contains(kNSFW)) {
        result.insert(0, kNSFW);
      }
      if (tagType.contains(kBDSM) && !result.contains(kBDSM)) {
        result.insert(0, kBDSM);
      }
    }

    return result.take(3).toList(); // 确保最多3个标签
  }
}
