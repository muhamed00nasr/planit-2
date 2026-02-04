import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final Color planItCyan = const Color(0xFF3DDBE1);
  String _paymentMethod = "card";
  bool _isProcessing = false;
  bool _isComplete = false;

  // 1. PDF GENERATION LOGIC (Updated with £)
  Future<void> _generatePdfReceipt() async {
    final pdf = pw.Document();
    final tealColor = PdfColor.fromInt(0xFF3DDBE1);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "PlanIt Receipt",
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: tealColor,
                      ),
                    ),
                    pw.Text(
                      "DATE: 31/01/2026",
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  "CUSTOMER: Farah Hicham",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Divider(color: tealColor),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [pw.Text("Vendor Deposit"), pw.Text("£5,000.00")],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [pw.Text("Service Fee"), pw.Text("£150.00")],
                ),
                pw.SizedBox(height: 20),
                pw.Divider(thickness: 2, color: tealColor),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "TOTAL PAID",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "£5,150.00",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: tealColor,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 50),
                pw.Center(
                  child: pw.Text(
                    "Confirmed via PlanIt App",
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void _handlePayment() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _isComplete = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isComplete) return _buildSuccessView();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Step 3 of 3: Secure Checkout",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Payment Method"),
            _buildMethodCard("card", "Credit Card", LucideIcons.creditCard),
            _buildMethodCard("bank", "Bank Transfer", LucideIcons.building2),
            _buildMethodCard(
              "digital",
              "Digital Wallet",
              LucideIcons.smartphone,
            ),
            const SizedBox(height: 24),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  _paymentMethod == "card"
                      ? _buildCardForm()
                      : _buildPlaceholderForm(),
            ),

            const SizedBox(height: 32),
            _buildOrderSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard(String val, String title, IconData icon) {
    bool isSelected = _paymentMethod == val;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = val),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? planItCyan.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? planItCyan : Colors.grey[200]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? planItCyan : Colors.grey),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Radio<String>(
              value: val,
              groupValue: _paymentMethod,
              activeColor: planItCyan,
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Column(
      children: [
        _buildTextField("Card Number", "XXXX XXXX XXXX XXXX"),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTextField("Expiry", "MM/YY")),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField("CVV", "123")),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPlaceholderForm() => const Padding(
    padding: EdgeInsets.all(10),
    child: Text(
      "Details will be required in the next step.",
      style: TextStyle(color: Colors.grey),
    ),
  );

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount"),
              Text(
                "£5,150.00",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: planItCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isProcessing ? null : _handlePayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: planItCyan,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child:
                _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                      "Pay Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.checkCircle,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                "Success!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Farah, your booking is confirmed.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              OutlinedButton.icon(
                onPressed: _generatePdfReceipt,
                icon: const Icon(LucideIcons.download),
                label: const Text("Download Receipt"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: planItCyan,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed:
                    () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: planItCyan,
                  minimumSize: const Size(double.infinity, 55),
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}
