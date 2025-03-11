class Medicine {
  final String id;
  final String name;
  final String description;
  final String dosage;
  final double price;
  final bool inStock;
  final String imageUrl;

  Medicine({
    required this.id,
    required this.name,
    required this.description,
    required this.dosage,
    required this.price,
    required this.inStock,
    required this.imageUrl,
  });

  get originalPrice => null;
}
