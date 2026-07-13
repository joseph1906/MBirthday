import 'dart:async';
import 'package:flutter/material.dart';

/// Full-screen photo sequence, shown after tapping Unlock.
///
/// Auto-advances through [photoAssets] with a subtle Ken Burns zoom and a
/// crossfade between frames. Tapping the right side skips ahead, the left
/// side goes back, and there's a "Skip" action to jump straight to the
/// letter. Calls [onFinished] once the last photo's dwell time elapses.
class PhotoSlideshow extends StatefulWidget {
  const PhotoSlideshow({
    super.key,
    required this.photoAssets,
    required this.onFinished,
    this.dwellDuration = const Duration(milliseconds: 2600),
  });

  final List<String> photoAssets;
  final VoidCallback onFinished;
  final Duration dwellDuration;

  @override
  State<PhotoSlideshow> createState() => _PhotoSlideshowState();
}

class _PhotoSlideshowState extends State<PhotoSlideshow> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scheduleNext();
  }

  void _scheduleNext() {
    _timer?.cancel();
    _timer = Timer(widget.dwellDuration, _advance);
  }

  void _advance() {
    if (!mounted) return;
    if (_index >= widget.photoAssets.length - 1) {
      widget.onFinished();
      return;
    }
    setState(() => _index++);
    _scheduleNext();
  }

  void _goBack() {
    if (_index == 0) return;
    setState(() => _index--);
    _scheduleNext();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        final width = MediaQuery.of(context).size.width;
        if (details.localPosition.dx < width / 2) {
          _goBack();
        } else {
          _advance();
        }
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _KenBurnsImage(
                key: ValueKey(_index),
                assetPath: widget.photoAssets[_index],
                duration: widget.dwellDuration +
                    const Duration(milliseconds: 500),
              ),
            ),
            // Bottom gradient so any future captions/UI stay legible.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 160,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: widget.onFinished,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black.withOpacity(0.25),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: const Text('Skip'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single photo that slowly zooms in for the duration it's on screen —
/// the classic "Ken Burns" documentary pan/zoom effect.
class _KenBurnsImage extends StatefulWidget {
  const _KenBurnsImage({super.key, required this.assetPath, required this.duration});

  final String assetPath;
  final Duration duration;

  @override
  State<_KenBurnsImage> createState() => _KenBurnsImageState();
}

class _KenBurnsImageState extends State<_KenBurnsImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();
    _scale = Tween<double>(begin: 1.0, end: 1.12)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) => Transform.scale(scale: _scale.value, child: child),
      child: Image.asset(widget.assetPath, fit: BoxFit.cover),
    );
  }
}

