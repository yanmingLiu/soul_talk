import 'package:flutter/material.dart';
import 'package:soul_talk/domain/entities/figure.dart';

class P006Title extends StatelessWidget {
  const P006Title({super.key, required this.role, this.onTapClose});

  final Figure role;
  final VoidCallback? onTapClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          role.name ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (role.age != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: const Color(0x80DF78B1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role.age.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}
