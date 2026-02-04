import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'widgets/welcome_screen.dart';
import 'widgets/UserTypePage.dart';
import 'widgets/home_feed.dart';
import 'widgets/package_builder.dart';
import 'widgets/messages_list.dart';
import 'widgets/profile_page.dart';
import 'widgets/budget_page.dart';
import 'models/vendor.dart';

void main() => runApp(const PlanItApp());

const Color planItCyan = Color(0xFF3DDBE1);

class PlanItApp extends StatelessWidget {
  const PlanItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanIt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: planItCyan),
      ),
      // Starts with the Animated Video Welcome Screen
      home: const WelcomeScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final Set<String> _favoritedIds = {};

  final List<Vendor> _allVendors = [
    const Vendor(
      id: "1",
      name: "Elegant Events Catering",
      category: "Catering",
      imageUrl:
          "https://images.unsplash.com/photo-1555244162-803834f70033?w=500",
      rating: 4.8,
      price: 15000,
    ),
    const Vendor(
      id: "2",
      name: "Azure Ballroom",
      category: "Venues",
      imageUrl:
          "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=500",
      rating: 4.9,
      price: 45000,
    ),
    const Vendor(
      id: "3",
      name: "Glow Makeup Artistry",
      category: "Makeup/Hair",
      imageUrl:
          "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=500",
      rating: 4.7,
      price: 3500,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeFeed(
        allVendors: _allVendors,
        favoritedIds: _favoritedIds,
        onFavoriteToggle:
            (id) => setState(() {
              _favoritedIds.contains(id)
                  ? _favoritedIds.remove(id)
                  : _favoritedIds.add(id);
            }),
      ),
      const PackageBuilder(),
      const MessagesList(),
      ProfilePage(favoritedIds: _favoritedIds, allVendors: _allVendors),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const AnimatedGradientHeader(),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.fileEdit, color: planItCyan, size: 24),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BudgetPage()),
                ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: planItCyan,
        unselectedItemColor: const Color(0xFFBCC6CC),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.package),
            label: "Plans",
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.messageSquare),
            label: "Chat",
          ),
          BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: "Me"),
        ],
      ),
    );
  }
}

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
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
              const Icon(LucideIcons.sun, color: Color(0xFFFFF4BC), size: 24),
            ],
          ),
        ),
        const SizedBox(width: 10),
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
