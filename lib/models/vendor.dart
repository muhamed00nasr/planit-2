class Vendor {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final double price; // ADD THIS

  const Vendor({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.price, // ADD THIS
  });
}
