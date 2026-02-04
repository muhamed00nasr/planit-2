import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'UserTypePage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _controller;
  bool _isButtonVisible = false;
  final Color planItCyan = const Color(0xFF3DDBE1);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/logo_anim.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) setState(() => _isButtonVisible = true);
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.3),
            child:
                _controller.value.isInitialized
                    ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                    : CircularProgressIndicator(color: planItCyan),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: _isButtonVisible ? 1.0 : 0.0,
                child: _buildWelcomeButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: planItCyan.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          _controller.pause();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserTypePage()),
          );
        },
        icon: const Text(
          "Get Started",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        label: const Icon(LucideIcons.arrowRight, color: Colors.white),
        style: ElevatedButton.styleFrom(
          backgroundColor: planItCyan,
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
