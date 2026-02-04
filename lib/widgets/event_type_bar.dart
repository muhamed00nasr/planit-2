import 'package:flutter/material.dart';

class EventTypeBar extends StatelessWidget {
  final String selectedType;
  final Function(String) onSelect;

  const EventTypeBar({
    super.key,
    required this.selectedType,
    required this.onSelect,
  });

  final List<String> types = const [
    'weddings',
    'birthdays',
    'corporate',
    'parties',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: types.length,
        itemBuilder: (context, index) {
          final type = types[index];
          final isSelected = selectedType == type;

          return GestureDetector(
            onTap: () => onSelect(type),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                // Use gradient if selected, otherwise light grey
                gradient:
                    isSelected
                        ? const LinearGradient(
                          colors: [Color(0xFF67FCD8), Color(0xFF77DBF4)],
                        )
                        : null,
                color: isSelected ? null : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  type[0].toUpperCase() + type.substring(1),
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
