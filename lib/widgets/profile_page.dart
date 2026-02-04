import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/vendor.dart';
import 'vendor_detail.dart';

class ProfilePage extends StatefulWidget {
  final Set<String> favoritedIds;
  final List<Vendor> allVendors;

  const ProfilePage({
    super.key,
    required this.favoritedIds,
    required this.allVendors,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color planItCyan = const Color(0xFF3DDBE1);

  // Editable Values
  String _budget = "24,000";
  String _guests = "150";

  void _showEditDialog(String title, String currentVal, bool isBudget) {
    TextEditingController controller = TextEditingController(text: currentVal);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Edit $title"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: isBudget ? "\$ " : "",
                hintText: "Enter amount",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: planItCyan),
                onPressed: () {
                  setState(() {
                    if (isBudget) {
                      _budget = controller.text;
                    } else {
                      _guests = controller.text;
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteVendors =
        widget.allVendors
            .where((v) => widget.favoritedIds.contains(v.id))
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER SECTION
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(LucideIcons.settings, color: Colors.black54),
                      Text(
                        "My Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                      const Icon(LucideIcons.logOut, color: Colors.black54),
                    ],
                  ),
                  const SizedBox(height: 25),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: planItCyan,
                    child: const CircleAvatar(
                      radius: 47,
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=500&auto=format&fit=crop",
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Farah Hicham",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: planItCyan.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Wedding • Oct 24, 2026",
                      style: TextStyle(
                        color: planItCyan,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. EDITABLE SUMMARY CARDS
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _buildEditableStatCard(
                    "Total Budget",
                    "\$$_budget",
                    LucideIcons.wallet,
                    planItCyan,
                    () => _showEditDialog("Budget", _budget, true),
                  ),
                  const SizedBox(width: 15),
                  _buildEditableStatCard(
                    "Guest List",
                    _guests,
                    LucideIcons.users,
                    const Color(0xFFFFD8BE),
                    () => _showEditDialog("Guests", _guests, false),
                  ),
                ],
              ),
            ),

            // 3. SAVED VENDORS HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Saved Experts",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${favoriteVendors.length} saved",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),

            // 4. FAVORITES LIST
            favoriteVendors.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  itemCount: favoriteVendors.length,
                  itemBuilder: (context, index) {
                    final vendor = favoriteVendors[index];
                    return _buildFavoriteTile(context, vendor, planItCyan);
                  },
                ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableStatCard(
    String title,
    String val,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap, // Clicks open the edit dialog
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const Icon(
                    LucideIcons.pencil,
                    size: 14,
                    color: Colors.black12,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                val,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteTile(
    BuildContext context,
    Vendor vendor,
    Color brandColor,
  ) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorDetail(vendor: vendor),
            ),
          ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                vendor.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    vendor.category,
                    style: TextStyle(
                      color: brandColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, color: Colors.grey[300], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(LucideIcons.heart, size: 50, color: Colors.grey[200]),
          const SizedBox(height: 15),
          const Text(
            "No saved vendors yet",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
