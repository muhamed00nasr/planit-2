import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class VendorScreen extends StatefulWidget {
  final String eventType;
  final String tier;
  final String venue;
  final int venueFee;
  final int packageCost;
  final List<String> items;
  final int startingBudget;

  const VendorScreen({
    super.key,
    required this.eventType,
    required this.tier,
    required this.venue,
    required this.venueFee,
    required this.packageCost,
    required this.items,
    required this.startingBudget,
  });

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  late int _remainingBudget;
  final Set<String> _hired = {};
  // Standardized average vendor fee for the UK market
  final int _avgVendorFee = 500;

  @override
  void initState() {
    super.initState();
    // Calculate initial pool: Target Budget - (Venue + Base Package)
    _remainingBudget =
        widget.startingBudget - (widget.venueFee + widget.packageCost);
  }

  void _toggleVendor(String item) {
    setState(() {
      if (_hired.contains(item)) {
        _hired.remove(item);
        _remainingBudget += _avgVendorFee;
      } else {
        _hired.add(item);
        _remainingBudget -= _avgVendorFee;
      }
    });
  }

  void _showCheckoutSummary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FINAL BILLING SUMMARY",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const Divider(height: 30),
                _summaryRow("Event Type", widget.eventType),
                _summaryRow(
                  "Venue Hire (${widget.venue})",
                  "£${widget.venueFee}",
                ),
                _summaryRow(
                  "${widget.tier} Package Base",
                  "£${widget.packageCost}",
                ),
                _summaryRow(
                  "Professional Fees (${_hired.length} vendors)",
                  "£${_hired.length * _avgVendorFee}",
                ),
                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TOTAL ESTIMATED",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "£${widget.startingBudget - _remainingBudget}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF4ECDC4),
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ECDC4),
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Confirm Selection",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9F8),
      appBar: AppBar(
        title: const Text("Hire Professionals"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildBudgetDisplay(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: widget.items.map((s) => _buildVendorTile(s)).toList(),
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildBudgetDisplay() {
    bool over = _remainingBudget < 0;
    // Calculate percentage spent
    double spentPercent =
        (widget.startingBudget - _remainingBudget) / widget.startingBudget;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "REMAINING BUDGET POOL",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black26,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    "£$_remainingBudget",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: over ? Colors.red : const Color(0xFF4ECDC4),
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor:
                    over
                        ? Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                child: Icon(
                  over ? LucideIcons.alertTriangle : LucideIcons.checkCircle,
                  color: over ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: spentPercent.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[100],
              color: over ? Colors.red : const Color(0xFF4ECDC4),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorTile(String service) {
    bool isSel = _hired.contains(service);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _toggleVendor(service),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isSel
                    ? const Color(0xFF4ECDC4).withOpacity(0.05)
                    : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSel ? const Color(0xFF4ECDC4) : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(
              isSel ? LucideIcons.checkCircle : LucideIcons.plusCircle,
              color: isSel ? const Color(0xFF4ECDC4) : Colors.grey[300],
            ),
            title: Text(
              service,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "~£$_avgVendorFee",
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 30),
      color: Colors.white,
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4ECDC4),
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          onPressed: _showCheckoutSummary,
          child: const Text(
            "View Breakdown",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
