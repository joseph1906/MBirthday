import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A single balloon that drifts upward and fades out, then removes itself.
/// Mirrors the `.balloon` CSS animation in the original HTML.
class BalloonWidget extends StatefulWidget {
  const BalloonWidget({
    super.key,
    required this.left,
    required this.screenHeight,
    required this.onFinished,
  });

  final double left;
  final double screenHeight;
  final VoidCallback onFinished;

  @override
  State<BalloonWidget> createState() => _BalloonWidgetState();
}

class _BalloonWidgetState extends State<BalloonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _riseAnimation;
  late final Animation<double> _fadeAnimation;
  late final Color _color;
  late final double _rotation;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _color = AppColors.balloonColors[
        random.nextInt(AppColors.balloonColors.length)];
    _rotation = random.nextDouble() * 45 * (pi / 180);

    final durationSeconds = 4 + random.nextDouble() * 4;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (durationSeconds * 1000).round()),
    );

    _riseAnimation = Tween<double>(
      begin: -100,
      end: -(widget.screenHeight + 200),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _fadeAnimation = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0)),
    );

    _controller.forward().whenComplete(widget.onFinished);
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
        return Positioned(
          left: widget.left,
          bottom: -_riseAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value.clamp(0.0, 1.0),
            child: Transform.rotate(
              angle: _rotation * _controller.value,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        width: 50,
        height: 70,
        decoration: BoxDecoration(
          color: _color,
          border: _color == Colors.white
              ? Border.all(color: AppColors.outlineVariant)
              : null,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.elliptical(25, 28),
            topRight: Radius.elliptical(25, 28),
            bottomLeft: Radius.elliptical(25, 42),
            bottomRight: Radius.elliptical(25, 42),
          ),
        ),
      ),
    );
  }
}

/// Overlay that periodically spawns [BalloonWidget]s for ~15 seconds,
/// matching the JS `setInterval(createBalloon, 400)` behavior.
class BalloonOverlay extends StatefulWidget {
  const BalloonOverlay({super.key, required this.active});

  final bool active;

  @override
  State<BalloonOverlay> createState() => _BalloonOverlayState();
}

class _BalloonOverlayState extends State<BalloonOverlay> {
  final List<Widget> _balloons = [];
  final Random _random = Random();
  int _tick = 0;

  @override
  void didUpdateWidget(covariant BalloonOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _startSpawning();
    }
  }

  void _startSpawning() {
    const spawnInterval = Duration(milliseconds: 400);
    const totalDuration = Duration(seconds: 15);
    final endTime = DateTime.now().add(totalDuration);

    void spawnLoop() {
      if (!mounted || DateTime.now().isAfter(endTime)) return;
      _spawnBalloon();
      Future.delayed(spawnInterval, spawnLoop);
    }

    spawnLoop();
  }

  void _spawnBalloon() {
    final size = MediaQuery.of(context).size;
    final left = _random.nextDouble() * (size.width - 50);
    final key = ValueKey('balloon_${_tick++}');
    late Widget balloon;
    balloon = BalloonWidget(
      key: key,
      left: left,
      screenHeight: size.height,
      onFinished: () {
        if (mounted) {
          setState(() => _balloons.remove(balloon));
        }
      },
    );
    if (mounted) {
      setState(() => _balloons.add(balloon));
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(clipBehavior: Clip.none, children: _balloons),
    );
  }
}
