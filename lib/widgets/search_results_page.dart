import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/vendor.dart';
import 'vendor_detail.dart';

const Color planItCyan = Color(0xFF3DDBE1);

class SearchResultsPage extends StatefulWidget {
  final String initialQuery;
  final List<Vendor> allVendors;
  final Set<String> favoritedIds;
  final Function(String) onFavoriteToggle;

  const SearchResultsPage({
    super.key,
    required this.initialQuery,
    required this.allVendors,
    required this.favoritedIds,
    required this.onFavoriteToggle,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late String _currentQuery;
  late TextEditingController _searchController;
  int _activeSortIndex = 0;
  String _selectedLocation = "Cairo, Egypt";

  // List of areas for the picker
  final List<String> _areas = [
    "New Cairo",
    "New Giza",
    "Maadi",
    "Zamalek",
    "6th of October",
  ];

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.initialQuery;
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  // --- NEW FUNCTION: Show the Area Picker ---
  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Sheet only takes needed space
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Area",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              // Generate the list of areas
              ..._areas.map(
                (area) => ListTile(
                  leading: const Icon(
                    LucideIcons.mapPin,
                    size: 18,
                    color: planItCyan,
                  ),
                  title: Text(area),
                  onTap: () {
                    setState(() => _selectedLocation = "$area, Egypt");
                    Navigator.pop(context); // Close the sheet
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Vendor> results =
        widget.allVendors.where((v) {
          final matchesQuery =
              v.name.toLowerCase().contains(_currentQuery.toLowerCase()) ||
              v.category.toLowerCase().contains(_currentQuery.toLowerCase());
          return matchesQuery;
        }).toList();

    if (_activeSortIndex == 1) {
      results.sort((a, b) => a.price.compareTo(b.price));
    } else if (_activeSortIndex == 2) {
      results.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (val) => setState(() => _currentQuery = val),
          decoration: InputDecoration(
            hintText: "Search for services...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. LOCATION BAR (Press to trigger picker)
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: InkWell(
              onTap: _showLocationPicker, // Call the picker here
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: planItCyan.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: planItCyan.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.mapPin, color: planItCyan, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      _selectedLocation,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: planItCyan,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. SORTING CHIPS BAR
          Container(
            height: 55,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              children: [
                _buildSortChip("All Results", 0),
                _buildSortChip("Price: Low to High", 1),
                _buildSortChip("Highest Rated", 2),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),

          // 3. RESULTS LIST
          Expanded(
            child:
                results.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      itemCount: results.length,
                      itemBuilder:
                          (context, index) => _buildVendorCard(results[index]),
                    ),
          ),
        ],
      ),
    );
  }

  // Helper UI methods (Sort chips, Vendor cards) remain the same...
  Widget _buildSortChip(String label, int index) {
    bool isSelected = _activeSortIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeSortIndex = index),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? planItCyan : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildVendorCard(Vendor vendor) {
    bool isFavorited = widget.favoritedIds.contains(vendor.id);
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorDetail(vendor: vendor),
            ),
          ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Stack(
                children: [
                  Image.network(
                    vendor.imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          Text(
                            " ${vendor.rating}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => widget.onFavoriteToggle(vendor.id),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              title: Text(
                vendor.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                vendor.category,
                style: const TextStyle(
                  color: planItCyan,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "£${vendor.price.toInt()}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const Text(
                    "starting",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No results for '$_currentQuery'",
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
