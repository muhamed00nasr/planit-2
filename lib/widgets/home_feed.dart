import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/vendor.dart';
import 'vendor_detail.dart';
import 'search_results_page.dart';

const Color planItCyan = Color(0xFF3DDBE1);

class HomeFeed extends StatefulWidget {
  final List<Vendor> allVendors;
  final Set<String> favoritedIds;
  final Function(String) onFavoriteToggle;

  const HomeFeed({
    super.key,
    required this.allVendors,
    required this.favoritedIds,
    required this.onFavoriteToggle,
  });

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  String _selectedCategory = "All";
  int _activeFilter = 0; // 0: Default, 1: Name Length, 2: Rating
  String _selectedLocation = "Cairo, Egypt";

  final List<Map<String, dynamic>> _categories = [
    {"name": "All", "icon": LucideIcons.layoutGrid, "color": planItCyan},
    {
      "name": "Venues",
      "icon": LucideIcons.building,
      "color": const Color(0xFFFFD8BE),
    },
    {
      "name": "Suits/Dresses",
      "icon": LucideIcons.shirt,
      "color": const Color(0xFFC5CAE9),
    },
    {
      "name": "Catering",
      "icon": LucideIcons.utensils,
      "color": const Color(0xFFFFF4BC),
    },
    {
      "name": "Photography",
      "icon": LucideIcons.camera,
      "color": const Color(0xFFD4EBD0),
    },
    {
      "name": "Decor",
      "icon": LucideIcons.palette,
      "color": const Color(0xFFF3D1F4),
    },
    {
      "name": "Makeup/Hair",
      "icon": LucideIcons.sparkles,
      "color": const Color(0xFFD1E8FF),
    },
    {
      "name": "Jewelry",
      "icon": LucideIcons.gem,
      "color": const Color(0xFFFFE0B2),
    },
    {
      "name": "Music/DJ",
      "icon": LucideIcons.music,
      "color": const Color(0xFFFFE5D9),
    },
    {
      "name": "Invitations",
      "icon": LucideIcons.scrollText,
      "color": const Color(0xFFDCEDC8),
    },
    {
      "name": "Transport",
      "icon": LucideIcons.car,
      "color": const Color(0xFFB9FBC0),
    },
  ];

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Area",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _locationTile("New Cairo, Egypt"),
              _locationTile("Zayed City, Egypt"),
              _locationTile("Maadi, Egypt"),
              _locationTile("Heliopolis, Egypt"),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _locationTile(String location) {
    return ListTile(
      leading: const Icon(LucideIcons.mapPin, color: planItCyan),
      title: Text(location),
      onTap: () {
        setState(() => _selectedLocation = location);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter & Sort Logic
    List<Vendor> filtered =
        widget.allVendors.where((v) {
          return _selectedCategory == "All" || v.category == _selectedCategory;
        }).toList();

    if (_activeFilter == 1) {
      filtered.sort((a, b) => a.name.length.compareTo(b.name.length));
    } else if (_activeFilter == 2) {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    final featuredVendors = widget.allVendors.take(3).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. LOCATION BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: InkWell(
              onTap: _showLocationPicker,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: planItCyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.mapPin, color: planItCyan, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      _selectedLocation,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_down, color: planItCyan),
                  ],
                ),
              ),
            ),
          ),

          // 2. SEARCH & FILTER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => SearchResultsPage(
                                  initialQuery: "",
                                  allVendors: widget.allVendors,
                                  favoritedIds: widget.favoritedIds,
                                  onFavoriteToggle: widget.onFavoriteToggle,
                                ),
                          ),
                        ),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(LucideIcons.search, size: 20, color: planItCyan),
                          SizedBox(width: 10),
                          Text(
                            "Search Planit...",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap:
                      () => setState(
                        () => _activeFilter = (_activeFilter + 1) % 3,
                      ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _activeFilter == 0 ? Colors.white : planItCyan,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      _activeFilter == 1
                          ? LucideIcons.arrowDownNarrowWide
                          : _activeFilter == 2
                          ? LucideIcons.star
                          : LucideIcons.slidersHorizontal,
                      color: _activeFilter == 0 ? Colors.grey : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. FEATURED SECTION
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            child: Text(
              "Top Rated Experts",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.88),
              itemCount: featuredVendors.length,
              itemBuilder:
                  (context, index) =>
                      _buildFeaturedCard(featuredVendors[index]),
            ),
          ),

          const SizedBox(height: 25),

          // 4. CATEGORY LIST
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                bool isSelected = _selectedCategory == cat['name'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat['name']),
                  child: Container(
                    width: 90,
                    margin: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? cat['color'] : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  isSelected ? 0.1 : 0.03,
                                ),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            cat['icon'],
                            color: isSelected ? Colors.black87 : cat['color'],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat['name'],
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 5. RESULTS LIST
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            child: Text(
              "Results in $_selectedCategory",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          filtered.isEmpty
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text("No vendors found"),
                ),
              )
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filtered.length,
                itemBuilder:
                    (context, index) => _buildVendorCard(filtered[index]),
              ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- Card Builders stay as you had them ---
  Widget _buildFeaturedCard(Vendor vendor) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorDetail(vendor: vendor),
            ),
          ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image: DecorationImage(
            image: NetworkImage(vendor.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.8), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "${vendor.rating}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                vendor.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                vendor.category,
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVendorCard(Vendor vendor) {
    bool isLiked = widget.favoritedIds.contains(vendor.id);
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
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 15,
                    left: 15,
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
                    top: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: () => widget.onFavoriteToggle(vendor.id),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.pink[300] : Colors.black26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                vendor.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                vendor.category,
                style: const TextStyle(color: planItCyan),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.black12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
