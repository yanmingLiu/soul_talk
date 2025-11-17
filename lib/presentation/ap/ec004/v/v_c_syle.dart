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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Styles:",
            style: TextStyle(
              color: Color(0xFF595959),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 79.0 / 32.0,
            ),
            itemBuilder: (_, index) {
              final item = list[index];
              final isSelected = item.style == selectedStyel?.style;
              return _buildItem(item, isSelected);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(GenStyles item, bool isSelected) {
    return GestureDetector(
      onTap: () {
        onChooseed(item);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00AB8E) : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          spacing: 4,
          children: [
            VImage(
              url: item.icon ?? '',
              width: 14,
              color: isSelected ? Colors.white : const Color(0xFF666666),
            ),
            Expanded(
              child: Text(
                item.name ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF666666),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
