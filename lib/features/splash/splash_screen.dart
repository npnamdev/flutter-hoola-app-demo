import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/app/router.dart';
import 'package:my_app/features/auth/providers/auth_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    // Start auth check as soon as possible (with a minimal splash display time)
    _kickoffAuthRedirect();
  }

  Future<void> _kickoffAuthRedirect() async {
    // Ensure splash visible at least 1200ms for UX
    final minDisplay = Future.delayed(const Duration(milliseconds: 1200));
    bool loggedIn = false;
    try {
      loggedIn = await ref.read(authStatusProvider.future);
    } catch (_) {
      loggedIn = false; // On error treat as logged out
    }
    await minDisplay;
    if (!mounted || _navigated) return;
    _navigated = true;
    if (loggedIn) {
      context.go(AppRoutes.homeShell);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Animated radial soft blobs for subtle movement
  Widget _animatedBlob({
    required double size,
    required Color color,
    required Offset origin,
    double travel = 28,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value * 2 * pi;
        final dx = origin.dx + cos(t) * travel;
        final dy = origin.dy + sin(t) * travel;
        return Positioned(
          left: dx,
          top: dy,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [color, Colors.transparent],
                stops: const [0, 1],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final anim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated sweeping gradient background
          AnimatedBuilder(
            animation: anim,
            builder: (context, _) {
              final shift = (anim.value * 0.4) - 0.2; // -0.2 .. 0.2
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFF21177D),
                      Color(0xFF3927D6),
                      Color(0xFF5E4FF3),
                    ],
                    begin: Alignment(-1 + shift, -1),
                    end: Alignment(1 - shift, 1),
                  ),
                ),
              );
            },
          ),

          // Subtle animated blobs
          _animatedBlob(
            size: 220,
            color: Colors.white.withOpacity(.10),
            origin: const Offset(40, 140),
            travel: 22,
          ),
          _animatedBlob(
            size: 160,
            color: Colors.pinkAccent.withOpacity(.15),
            origin: const Offset(250, 480),
            travel: 26,
          ),
          _animatedBlob(
            size: 190,
            color: Colors.blueAccent.withOpacity(.12),
            origin: const Offset(90, 620),
            travel: 24,
          ),

          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(.25),
                      width: 1.4,
                    ),
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(.25),
                        Colors.white.withOpacity(0),
                      ],
                      stops: const [0, 1],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.flutter_dash,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  'Hoola',
                  style: GoogleFonts.lato(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Học tập dễ dàng hơn mỗi ngày',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 38),
                _ProgressBar(animation: anim),
              ],
            ),
          ),
          // Bottom small tagline / version (optional placeholder)
          Positioned(
            bottom: 26,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: .75,
              child: Text(
                'Đang chuẩn bị trải nghiệm của bạn...',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Colors.white70,
                  letterSpacing: .5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final Animation<double> animation;
  const _ProgressBar({required this.animation});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final v = (sin(animation.value * 2 * pi) + 1) / 2; // 0..1 oscillation
        return Container(
          width: 180,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.18),
            borderRadius: BorderRadius.circular(40),
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: .2 + v * .8,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFDDD9FF)],
                ),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
