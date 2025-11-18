import 'package:flutter/material.dart';
import 'package:soul_talk/domain/entities/gen_styles.dart';
import 'package:soul_talk/presentation/v000/v_image.dart';

class VCStyle extends StatelessWidget {
  const VCStyle({
    super.key,
    required this.list,
    required this.onChooseed,
    this.selectedStyel,
  });

  final List<GenStyles> list;
  final GenStyles? selectedStyel;
  final void Function(GenStyles data) onChooseed;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: list.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final item = list[index];
          final isSelected = item.style == selectedStyel?.style;
          return _buildItem(item, isSelected);
        },
      ),
    );
  }

  Widget _buildItem(GenStyles item, bool isSelected) {
    return GestureDetector(
      onTap: () {
        onChooseed(item);
      },
      child: SizedBox(
        height: 84,
        width: 52,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 4,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                border: BoxBorder.all(
                  width: 2,
                  color: isSelected ? const Color(0xFF55CFDA) : Colors.white,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: VImage(
                  url: item.icon ?? '',
                  width: 14,
                  color: const Color(0xFF595959),
                ),
              ),
            ),
            Text(
              item.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF595959),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
