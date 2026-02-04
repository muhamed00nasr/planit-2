import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'search_results_page.dart';
import '../models/vendor.dart';

class SearchBarWidget extends StatelessWidget {
  final List<Vendor> allVendors; // Needed to pass data to the next page

  const SearchBarWidget({super.key, required this.allVendors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          // Use onSubmitted to navigate only when the user is done typing
          onSubmitted: (query) {
            if (query.trim().isEmpty) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => SearchResultsPage(
                      initialQuery: query,
                      allVendors: allVendors,
                      favoritedIds:
                          const {}, // Initialize empty or pass from parent
                      onFavoriteToggle: (id) {
                        // Handle favorite logic
                      },
                    ),
              ),
            );
          },
          textInputAction:
              TextInputAction
                  .search, // Changes 'Enter' to a Search icon on keyboard
          decoration: InputDecoration(
            hintText: 'Search vendors...',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            prefixIcon: ShaderMask(
              shaderCallback:
                  (bounds) => const LinearGradient(
                    colors: [Color(0xFF67FCD8), Color(0xFF77DBF4)],
                  ).createShader(bounds),
              child: const Icon(
                LucideIcons.search,
                color: Colors.white,
                size: 20,
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }
}
