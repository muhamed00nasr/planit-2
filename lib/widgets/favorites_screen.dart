import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/vendor.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Vendor> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9F8),
      appBar: AppBar(
        title: const Text(
          "My Favorites",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          favorites.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.heartOff,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No favorites yet!",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final vendor = favorites[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          vendor.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: Colors.grey[200],
                                child: const Icon(LucideIcons.image),
                              ),
                        ),
                      ),
                      title: Text(
                        vendor.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        vendor.category,
                        style: const TextStyle(
                          color: Color(0xFF4ECDC4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(LucideIcons.chevronRight, size: 18),
                      onTap: () {
                        // Navigate to details if needed
                      },
                    ),
                  );
                },
              ),
    );
  }
}
