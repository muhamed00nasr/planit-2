import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/vendor.dart';
import 'chat_interface.dart';
import 'payment_page.dart';

class VendorDetail extends StatefulWidget {
  final Vendor vendor;
  const VendorDetail({super.key, required this.vendor});

  @override
  State<VendorDetail> createState() => _VendorDetailState();
}

class _VendorDetailState extends State<VendorDetail> {
  bool _isFavorited = false;
  final Color planItCyan = const Color(0xFF3DDBE1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. HERO IMAGE & BACK BUTTON
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            elevation: 0,
            stretch: true,
            backgroundColor: planItCyan,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(
                    LucideIcons.chevronLeft,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(widget.vendor.imageUrl, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. VENDOR CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Favorite Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.vendor.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.vendor.category,
                              style: TextStyle(
                                fontSize: 18,
                                color: planItCyan,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => setState(() => _isFavorited = !_isFavorited),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                _isFavorited
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            LucideIcons.heart,
                            color: _isFavorited ? Colors.red : Colors.grey[400],
                            fill: _isFavorited ? 1.0 : 0.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Quick Info Row (Rating, Location)
                  Row(
                    children: [
                      _buildQuickInfo(
                        LucideIcons.star,
                        "4.9 (120 reviews)",
                        Colors.orange,
                      ),
                      const SizedBox(width: 20),
                      _buildQuickInfo(
                        LucideIcons.mapPin,
                        "London, UK", // UPDATED for localization
                        Colors.grey,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    "About",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Creating unforgettable moments for your special day. ${widget.vendor.name} specializes in high-end ${widget.vendor.category.toLowerCase()} services across the UK, with a focus on elegance and client satisfaction.",
                    style: TextStyle(
                      color: Colors.grey[600],
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    "Portfolio",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Portfolio Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: 6,
                    itemBuilder:
                        (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            "https://picsum.photos/seed/${widget.vendor.id}$index/400",
                            fit: BoxFit.cover,
                          ),
                        ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. ACTION BUTTONS
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Chat Button
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ChatInterface(vendorName: widget.vendor.name),
                    ),
                  ),
              child: Container(
                height: 56,
                width: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: planItCyan, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(LucideIcons.messageSquare, color: planItCyan),
              ),
            ),
            const SizedBox(width: 16),
            // Book/Payment Button
            Expanded(
              child: GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage(),
                      ),
                    ),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: planItCyan,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: planItCyan.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfo(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
