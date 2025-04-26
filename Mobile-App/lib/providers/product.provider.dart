import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String _error = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get error => _error;

  String _fixImageUrl(String url) {
    // Replace localhost or 127.0.0.1 with 10.0.2.2 for Android emulator
    return url.replaceAll('http://localhost:3000', 'http://10.0.2.2:3000')
              .replaceAll('http://127.0.0.1:3000', 'http://10.0.2.2:3000');
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/products'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data.map((json) {
          final product = Product.fromJson(json);
          // Create a new Product with the fixed image URL
          return Product(
            id: product.id,
            name: product.name,
            type: product.type,
            price: product.price,
            isNew: product.isNew,
            rating: product.rating,
            description: product.description,
            mainImage: _fixImageUrl(product.mainImage),
          );
        }).toList();
      } else {
        _error = 'Failed to load products';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<Product?> getProductById(String productId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/products/$productId'));
      
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final product = Product.fromJson(data);
        
        // Create a new Product with fixed image URLs
        final fixedProduct = Product(
          id: product.id,
          name: product.name,
          type: product.type,
          price: product.price,
          isNew: product.isNew,
          rating: product.rating,
          description: product.description,
          mainImage: _fixImageUrl(product.mainImage),
          fullDescription: product.fullDescription,
          variants: product.variants,
          images: product.images?.map((url) => _fixImageUrl(url)).toList(),
        );
        
        _isLoading = false;
        notifyListeners();
        return fixedProduct;
      } else {
        _error = 'Failed to load product details';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'Error: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
} 