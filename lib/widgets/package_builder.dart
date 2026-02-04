import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'vendor_screen.dart';

class PackageBuilder extends StatefulWidget {
  const PackageBuilder({super.key});

  @override
  State<PackageBuilder> createState() => _PackageBuilderState();
}

class _PackageBuilderState extends State<PackageBuilder> {
  final Color _teal = const Color(0xFF4ECDC4);

  int _currentStep = 0;
  String _selectedEventType = "Wedding";

  // --- CONFIGURATION STATE ---
  int _userTotalBudget = 5000;
  String _selectedTier = "Basic";
  bool _includeVenue = false;
  String _venueType = "Ballroom";
  double _guestCount = 20;

  // --- DATA ---
  final Map<String, Map<String, dynamic>> _packageData = {
    "Wedding": {
      "Basic": {
        "items": ["Bridal Bouquet", "Table Decor", "Sound System"],
        "base": 1200,
      },
      "Standard": {
        "items": ["Photography", "Floral Arch", "Champagne Toast"],
        "base": 2800,
      },
      "Premium": {
        "items": ["Open Bar", "Live Band", "Luxury Car"],
        "base": 5500,
      },
    },
    "Birthday": {
      "Basic": {
        "items": ["Custom Cake", "Simple Balloons", "Playlist"],
        "base": 500,
      },
      "Standard": {
        "items": ["Photo Booth", "Catering", "Themed Invites"],
        "base": 1500,
      },
      "Premium": {
        "items": ["DJ Service", "Premium Balloon Wall", "Full Buffet"],
        "base": 3500,
      },
    },
    "Anniversary": {
      "Basic": {
        "items": ["Floral Bouquet", "Personalized Card", "Candlelit Setup"],
        "base": 450,
      },
      "Standard": {
        "items": [
          "Professional Photography",
          "Multi-course Dinner",
          "Live Violinist",
        ],
        "base": 1800,
      },
      "Premium": {
        "items": [
          "Luxury Suite Decor",
          "Private Yacht/Car",
          "Custom Jewelry Gift",
        ],
        "base": 4200,
      },
    },
    "Baby Shower": {
      "Basic": {
        "items": ["Diaper Cake", "Game Props", "Cupcakes"],
        "base": 400,
      },
      "Standard": {
        "items": ["Gender Reveal Setup", "Brunch Menu", "Mom-to-be Sash"],
        "base": 1200,
      },
      "Premium": {
        "items": ["Professional Decor", "Personalized Favors", "Mocktail Bar"],
        "base": 2500,
      },
    },
    "Corporate": {
      "Basic": {
        "items": ["Projector", "Coffee Station", "Badges"],
        "base": 800,
      },
      "Standard": {
        "items": ["Gala Dinner", "Keynote Speaker", "Materials"],
        "base": 3000,
      },
      "Premium": {
        "items": ["Translation", "Lounge", "Media Coverage"],
        "base": 7000,
      },
    },
    "Engagement": {
      "Basic": {
        "items": ["Ring Pillow", "Background Music", "Sparklers"],
        "base": 700,
      },
      "Standard": {
        "items": ["Professional Video", "Gourmet Dinner", "Floral Wall"],
        "base": 2200,
      },
      "Premium": {
        "items": ["Drone Footage", "Live Violinist", "Luxury Table Setting"],
        "base": 4500,
      },
    },
    "Private Party": {
      "Basic": {
        "items": ["Ambient Lights", "Self-Serve Bar", "Music"],
        "base": 600,
      },
      "Standard": {
        "items": ["Mixologist", "Appetizer Platter", "Props"],
        "base": 1800,
      },
      "Premium": {
        "items": ["Private Chef", "LED Floor", "Valet"],
        "base": 4000,
      },
    },
    "Graduation": {
      "Basic": {
        "items": ["Banner", "Snack Table", "Photo Spot"],
        "base": 300,
      },
      "Standard": {
        "items": ["Catered Lunch", "Diploma Frame Decor", "Slide Show"],
        "base": 1000,
      },
      "Premium": {
        "items": ["Live Performance", "Themed Party Favors", "Cocktail Hour"],
        "base": 2800,
      },
    },
  };

  final Map<String, Map<String, dynamic>> _venueOptions = {
    "Ballroom": {
      "min": 80,
      "max": 500,
      "icon": LucideIcons.castle,
      "fee": 2500,
    },
    "Garden": {"min": 20, "max": 150, "icon": LucideIcons.leaf, "fee": 1800},
    "Cafe": {"min": 2, "max": 40, "icon": LucideIcons.coffee, "fee": 600},
    "Bar/Pub": {"min": 2, "max": 80, "icon": LucideIcons.beer, "fee": 900},
  };

  final List<String> _customPool = [
    "Extra Security",
    "Live Streaming",
    "Makeup",
    "Drone",
    "Gift Bags",
  ];
  List<String> _selectedCustomItems = [];

  void _runOptimizer() {
    int venueFee =
        _includeVenue ? (_venueOptions[_venueType]!['fee'] as int) : 0;
    String recommended = "Basic";
    var eventPackages = _packageData[_selectedEventType]!;
    if ((eventPackages["Premium"]!['base'] + venueFee) <= _userTotalBudget) {
      recommended = "Premium";
    } else if ((eventPackages["Standard"]!['base'] + venueFee) <=
        _userTotalBudget) {
      recommended = "Standard";
    }
    setState(() => _selectedTier = recommended);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Optimized! For your £$_userTotalBudget budget, we recommend $recommended.",
        ),
        backgroundColor: _teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<String> _getFinalItems() {
    if (_selectedTier == "Custom") return _selectedCustomItems;
    var eventData = _packageData[_selectedEventType]!;
    List<String> stack = [...eventData["Basic"]!['items']];
    if (_selectedTier == "Standard" || _selectedTier == "Premium")
      stack.addAll(eventData["Standard"]!['items']);
    if (_selectedTier == "Premium")
      stack.addAll(eventData["Premium"]!['items']);
    return stack;
  }

  int _getPackageCost() {
    if (_selectedTier == "Custom") return _selectedCustomItems.length * 400;
    return _packageData[_selectedEventType]![_selectedTier]!['base'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9F8),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildCurrentView(),
      ),
    );
  }

  Widget _buildCurrentView() {
    if (_currentStep == 0) return _buildEventGrid();
    if (_currentStep == 1) return _buildBudgetEntry();
    return _buildConfigurator();
  }

  Widget _buildEventGrid() {
    final events = [
      {"name": "Wedding", "icon": LucideIcons.heart},
      {"name": "Birthday", "icon": LucideIcons.cake},
      {"name": "Anniversary", "icon": LucideIcons.calendarHeart},
      {"name": "Baby Shower", "icon": LucideIcons.baby},
      {"name": "Corporate", "icon": LucideIcons.briefcase},
      {"name": "Engagement", "icon": LucideIcons.gem},
      {"name": "Private Party", "icon": LucideIcons.glassWater},
      {"name": "Graduation", "icon": LucideIcons.graduationCap},
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 55),
          Text(
            "Event Architect",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: _teal,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemCount: events.length,
            itemBuilder:
                (context, index) => GestureDetector(
                  onTap:
                      () => setState(() {
                        _selectedEventType = events[index]['name'] as String;
                        _currentStep = 1;
                      }),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          events[index]['icon'] as IconData,
                          size: 40,
                          color: _teal,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          events[index]['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildBudgetEntry() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: Colors.black54),
              onPressed: () => setState(() => _currentStep = 0),
            ),
          ),
          const Spacer(),
          const Icon(LucideIcons.banknote, size: 60, color: Color(0xFF4ECDC4)),
          const SizedBox(height: 20),
          Text(
            "Target Budget for $_selectedEventType",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "£$_userTotalBudget",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: _teal,
            ),
          ),
          Slider(
            value: _userTotalBudget.toDouble(),
            min: 500,
            max: 50000,
            divisions: 99,
            activeColor: _teal,
            onChanged: (v) => setState(() => _userTotalBudget = v.toInt()),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _teal,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => setState(() => _currentStep = 2),
            child: const Text(
              "Continue to Design",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildConfigurator() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildVenueSection(),
              const SizedBox(height: 25),
              _buildGuestSlider(),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "SELECT PACKAGE TIER",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black26,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _runOptimizer,
                    icon: const Icon(LucideIcons.wand2, size: 14),
                    label: const Text(
                      "Optimize Budget",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(foregroundColor: _teal),
                  ),
                ],
              ),
              _buildTierTabs(),
              const SizedBox(height: 25),
              _selectedTier == "Custom"
                  ? _buildCustomPicker()
                  : _buildInclusionList(),
              const SizedBox(height: 120),
            ],
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildTierTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            ["Basic", "Standard", "Premium", "Custom"].map((t) {
              int pkgPrice =
                  (t == "Custom")
                      ? 0
                      : _packageData[_selectedEventType]![t]['base'];
              int venueFee =
                  _includeVenue
                      ? (_venueOptions[_venueType]!['fee'] as int)
                      : 0;
              bool isLocked = (pkgPrice + venueFee) > _userTotalBudget;
              return GestureDetector(
                onTap:
                    isLocked ? null : () => setState(() => _selectedTier = t),
                child: Opacity(
                  opacity: isLocked ? 0.4 : 1.0,
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: _selectedTier == t ? _teal : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          isLocked
                              ? Border.all(color: Colors.red.withOpacity(0.3))
                              : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              t,
                              style: TextStyle(
                                color:
                                    _selectedTier == t
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isLocked)
                              const Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Icon(
                                  LucideIcons.lock,
                                  size: 12,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          t == "Custom" ? "Manual Build" : "From £$pkgPrice",
                          style: TextStyle(
                            color:
                                _selectedTier == t
                                    ? Colors.white70
                                    : Colors.black38,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildVenueSection() {
    final v = _venueOptions[_venueType]!;
    bool isInvalid = _guestCount < v['min'] || _guestCount > v['max'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.mapPin,
                color: _includeVenue ? _teal : Colors.grey,
              ),
              const SizedBox(width: 15),
              const Text(
                "Rent a Venue",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Switch(
                value: _includeVenue,
                activeColor: _teal,
                onChanged: (v) => setState(() => _includeVenue = v),
              ),
            ],
          ),
          if (_includeVenue) ...[
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  _venueOptions.keys
                      .map(
                        (type) => GestureDetector(
                          onTap: () => setState(() => _venueType = type),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    _venueType == type
                                        ? _teal
                                        : _teal.withOpacity(0.1),
                                child: Icon(
                                  _venueOptions[type]!['icon'],
                                  color:
                                      _venueType == type ? Colors.white : _teal,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                type,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 15),
            Text(
              "${_venueType} Fee: £${v['fee']} | Capacity: ${v['min']}-${v['max']}",
              style: TextStyle(
                color: isInvalid ? Colors.red : _teal,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGuestSlider() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            "Guest Count: ${_guestCount.toInt()}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _guestCount,
            min: 2,
            max: 500,
            activeColor: _teal,
            onChanged: (v) => setState(() => _guestCount = v),
          ),
        ],
      ),
    );
  }

  Widget _buildInclusionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          _getFinalItems()
              .map(
                (item) => ListTile(
                  dense: true,
                  leading: Icon(LucideIcons.check, size: 16, color: _teal),
                  title: Text(item, style: const TextStyle(fontSize: 13)),
                ),
              )
              .toList(),
    );
  }

  Widget _buildCustomPicker() {
    return Wrap(
      spacing: 8,
      children:
          _customPool
              .map(
                (item) => FilterChip(
                  label: Text(item, style: const TextStyle(fontSize: 12)),
                  selected: _selectedCustomItems.contains(item),
                  onSelected:
                      (val) => setState(() {
                        val
                            ? _selectedCustomItems.add(item)
                            : _selectedCustomItems.remove(item);
                      }),
                ),
              )
              .toList(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 10, right: 20, bottom: 20),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(LucideIcons.chevronLeft),
            onPressed: () => setState(() => _currentStep = 1),
          ),
          Text(
            "$_selectedEventType Config",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            "£$_userTotalBudget",
            style: TextStyle(color: _teal, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(30),
      color: Colors.white,
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _teal,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (c) => VendorScreen(
                        eventType: _selectedEventType,
                        tier: _selectedTier,
                        venue: _includeVenue ? _venueType : "Private",
                        venueFee:
                            _includeVenue
                                ? _venueOptions[_venueType]!['fee']
                                : 0,
                        packageCost: _getPackageCost(),
                        items: _getFinalItems(),
                        startingBudget: _userTotalBudget,
                      ),
                ),
              ),
          child: const Text(
            "Select Vendors",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
