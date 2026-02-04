// lib/widgets/service_categories.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ServiceCategories extends StatelessWidget {
  const ServiceCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your gradient colors
    const primaryGradient = [Color(0xFF67FCD8), Color(0xFF77DBF4)];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4, // 4 items per row looks cleaner on white
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildItem('Venue', LucideIcons.building, primaryGradient),
        _buildItem('Food', LucideIcons.utensils, primaryGradient),
        _buildItem('Music', LucideIcons.music, primaryGradient),
        _buildItem('Photo', LucideIcons.camera, primaryGradient),
      ],
    );
  }

  Widget _buildItem(String title, IconData icon, List<Color> gradientColors) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [
                gradientColors[0].withOpacity(0.2),
                gradientColors[1].withOpacity(0.2),
              ],
            ),
          ),
          child: Icon(icon, color: gradientColors[1], size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
