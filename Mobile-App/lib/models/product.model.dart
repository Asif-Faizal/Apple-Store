class Product {
  final String id;
  final String name;
  final String type;
  final double price;
  final bool isNew;
  final double rating;
  final String description;
  final String mainImage;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.isNew,
    required this.rating,
    required this.description,
    required this.mainImage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      price: json['price'].toDouble(),
      isNew: json['isNew'],
      rating: json['rating'].toDouble(),
      description: json['description'],
      mainImage: json['mainImage'],
    );
  }
} 