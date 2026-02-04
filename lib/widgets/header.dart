import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

const Color planItCyan = Color(0xFF3DDBE1);

class AnimatedGradientHeader extends StatefulWidget {
  const AnimatedGradientHeader({super.key});

  @override
  State<AnimatedGradientHeader> createState() => _AnimatedGradientHeaderState();
}

class _AnimatedGradientHeaderState extends State<AnimatedGradientHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulse = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The Row is wrapped in a MouseRegion and GestureDetector for better UX
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The Animated Planet Logo
        ScaleTransition(
          scale: _pulse,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFF4BC),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/images/saturn.png',
                height: 32,
                width: 32,
                errorBuilder:
                    (c, e, s) => const Icon(
                      LucideIcons.sun,
                      color: Color(0xFFFFF4BC),
                      size: 24,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // The Gradient Text "Planit"
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [planItCyan, Color(0xFFA6F1F4)],
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: const Text(
            "Planit",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 28,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}
