import 'package:flutter/material.dart';
import 'package:soul_talk/presentation/v000/v_button.dart';

class VCCloseBtn extends StatelessWidget {
  const VCCloseBtn({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return VButton(
      width: 32,
      height: 32,
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0x40000000),
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(20),
            bottomStart: Radius.circular(20),
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.close,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}
