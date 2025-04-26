class Product {
  final String id;
  final String name;
  final String type;
  final double price;
  final bool isNew;
  final double rating;
  final String description;
  final String mainImage;
  final String? fullDescription;
  final List<String>? images;
  final List<ProductVariant>? variants;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.isNew,
    required this.rating,
    required this.description,
    required this.mainImage,
    this.fullDescription,
    this.images,
    this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<ProductVariant>? variantsList;
    if (json['variants'] != null) {
      variantsList = (json['variants'] as List)
          .map((v) => ProductVariant.fromJson(v))
          .toList();
    }
    
    List<String>? imagesList;
    if (json['images'] != null) {
      imagesList = (json['images'] as List).map((i) => i.toString()).toList();
    }
    
    return Product(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      price: (json['price'] ?? json['basePrice']).toDouble(),
      isNew: json['isNew'],
      rating: json['rating'].toDouble(),
      description: json['description'],
      mainImage: json['mainImage'],
      fullDescription: json['fullDescription'],
      images: imagesList,
      variants: variantsList,
    );
  }
}

class ProductVariant {
  final String id;
  final String name;
  final double price;
  final String color;

  ProductVariant({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      color: json['color'],
    );
  }
} 