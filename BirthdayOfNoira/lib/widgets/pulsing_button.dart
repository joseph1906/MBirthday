import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Recreates the `.pulse-animation` glowing/scaling button from the HTML.
class PulsingUnlockButton extends StatefulWidget {
  const PulsingUnlockButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<PulsingUnlockButton> createState() => _PulsingUnlockButtonState();
}

class _PulsingUnlockButtonState extends State<PulsingUnlockButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // 0 -> 0.7 progress mirrors the 70% keyframe, then eases back out.
        final t = _controller.value;
        final scale = 1.0 + (t < 0.7 ? (t / 0.7) * 0.05 : 0.05 * (1 - (t - 0.7) / 0.3));
        final glowOpacity = t < 0.7 ? 0.7 * (1 - t / 0.7) : 0.0;
        return Transform.scale(
          scale: _pressed ? 0.95 : scale,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryContainer.withOpacity(glowOpacity),
                  blurRadius: 30,
                  spreadRadius: 15 * (t < 0.7 ? t / 0.7 : 1),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Unlock Surprise', style: AppTextStyles.headlineSm(color: Colors.white)),
              const SizedBox(width: 12),
              const Icon(Icons.lock_open_rounded, color: AppColors.primaryFixed),
            ],
          ),
        ),
      ),
    );
  }
}
