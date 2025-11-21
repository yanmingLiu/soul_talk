import 'dart:async';

import 'package:flutter/material.dart';

class VipTimer extends StatefulWidget {
  const VipTimer({super.key});

  @override
  State<VipTimer> createState() => _VipTimerState();
}

class _VipTimerState extends State<VipTimer> {
  final ValueNotifier<Duration> _timeNotifier = ValueNotifier(
    const Duration(minutes: 30),
  );
  Timer? _timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Expiration',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        ValueListenableBuilder<Duration>(
          valueListenable: _timeNotifier,
          builder: (context, value, child) {
            final minutesStr = value.inMinutes.toString().padLeft(2, '0');
            final secondsStr = (value.inSeconds % 60).toString().padLeft(
                  2,
                  '0',
                );
            return Row(
              children: [
                _buildDigit(minutesStr[0]),
                const SizedBox(width: 4),
                _buildDigit(minutesStr[1]),
                const SizedBox(width: 8),
                const Text(
                  ':',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFDF78B1),
                  ),
                ),
                const SizedBox(width: 8),
                _buildDigit(secondsStr[0]),
                const SizedBox(width: 4),
                _buildDigit(secondsStr[1]),
              ],
            );
          },
        ),
      ],
    );
  }

  Container _buildDigit(String digit) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(6),
        border: BoxBorder.all(
          width: 1,
          color: const Color(0x33FFFFFF),
        ),
      ),
      child: Center(
        child: Text(
          digit,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = _timeNotifier.value;
      if (current.inSeconds == 0) {
        timer.cancel();
      } else {
        _timeNotifier.value = Duration(seconds: current.inSeconds - 1);
      }
    });
  }
}
