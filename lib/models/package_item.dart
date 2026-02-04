class PackageItem {
  final String id;
  final String category;
  final String name;
  final int price;
  bool included;

  PackageItem({
    required this.id,
    required this.category,
    required this.name,
    required this.price,
    this.included = false,
  });
}

class PresetPackage {
  final String id;
  final String name;
  final int price;
  final String description;
  final List<String> items;

  PresetPackage({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.items,
  });
}
