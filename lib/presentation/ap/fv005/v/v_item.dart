import 'package:flutter/material.dart';
import 'package:soul_talk/app/di_depency.dart';
import 'package:soul_talk/domain/entities/sku.dart';
import 'package:soul_talk/utils/extensions.dart';

class SkuItemWidget extends StatelessWidget {
  final SKU skuData;
  final bool isSelected;
  final VoidCallback onTap;
  final double? minWidth; // 改为可选的最小宽度

  const SkuItemWidget({
    super.key,
    required this.skuData,
    required this.isSelected,
    required this.onTap,
    this.minWidth, // 可选参数
  });

  @override
  Widget build(BuildContext context) {
    final isBest = (skuData.defaultSku ?? false) && DI.storage.isBest;
    final isLifetime = skuData.lifetime ?? false;
    final price = skuData.productDetails?.price ?? '-';
    final skuType = skuData.skuType;
    final tagMarginLeft = isBest ? 4.0 : 0.0;

    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            margin: EdgeInsets.only(top: 8, left: tagMarginLeft),
            constraints: const BoxConstraints(minWidth: 80, maxWidth: 180),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color:
                    isSelected ? const Color(0xFFDF78B1) : Colors.transparent,
                width: 2.0,
              ),
              color: isSelected
                  ? const Color(0x29DF78B1)
                  : const Color(0x29FFFFFF),
            ),
            child: DI.storage.isBest
                ? _buildBigVersionContent(price, isLifetime, skuType)
                : _buildSmallVersionContent(price),
          ),
        ),
        if (isBest) _buildBestOfferTag(),
      ],
    );
  }

  /// 构建大版本内容
  Widget _buildBigVersionContent(String price, bool isLifetime, int? skuType) {
    return _buildSubscriptionContent(price, isLifetime);
  }

  /// 构建小版本内容
  Widget _buildSmallVersionContent(String price) {
    final title = _getSkuTitle();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              price,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 2242,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建订阅版内容
  Widget _buildSubscriptionContent(String price, bool isLifetime) {
    final rawPrice = skuData.productDetails?.rawPrice ?? 0;
    final symbol = skuData.productDetails?.currencySymbol ?? '';
    final title = _getSkuTitle();

    String originalPrice = '';
    if (skuData.skuType == 2) {
      final weekPrice = numFixed(rawPrice / 4, position: 2);
      originalPrice = '$symbol$weekPrice';
    } else if (skuData.skuType == 3) {
      final weekPrice = numFixed(rawPrice / 48, position: 2);
      originalPrice = '$symbol$weekPrice';
    } else if (skuData.skuType == 4) {
      originalPrice = '$symbol${numFixed(rawPrice * 6, position: 2)}';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        isLifetime
            ? Row(
                spacing: 2,
                children: [
                  Flexible(
                    child: Text(
                      '+ ${skuData.number.toString()}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/diamond.png',
                    width: 22,
                  ),
                ],
              )
            : Row(
                spacing: 2,
                children: [
                  Flexible(
                    child: Text(
                      originalPrice,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Text(
                    '/Week',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0x80FFFFFF),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
        isLifetime
            ? Row(
                spacing: 4,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0x80FFFFFF),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0x80FFFFFF),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Color(0x80FFFFFF),
                    ),
                  ),
                ],
              )
            : Text(
                price,
                style: const TextStyle(
                  color: Color(0x80FFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
      ],
    );
  }

  /// 构建最佳优惠标签
  Widget _buildBestOfferTag() {
    return SizedBox(
      height: 24,
      width: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/hot@3x.png', fit: BoxFit.fill),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              "BEST OFFER",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 获取SKU标题
  String _getSkuTitle() {
    final skuType = skuData.skuType;

    switch (skuType) {
      case 2:
        return 'Monthly';
      case 3:
        return 'Yearly';
      case 4:
        return 'Lifetime';
      default:
        return '';
    }
  }
}
