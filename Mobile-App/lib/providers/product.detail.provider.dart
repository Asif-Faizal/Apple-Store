import 'package:flutter/material.dart';
import '../models/product.model.dart';
import 'product.provider.dart';

class ProductDetailProvider with ChangeNotifier {
  final ProductProvider _productProvider;
  final String productId;
  
  Product? _product;
  bool _isLoading = false;
  String _error = '';
  int _selectedImageIndex = 0;
  int _selectedVariantIndex = 0;
  bool _initialized = false;

  ProductDetailProvider(this._productProvider, this.productId);

  // Initialize the provider after the widget tree is built
  Future<void> initialize() async {
    if (!_initialized) {
      _initialized = true;
      await _fetchProductDetail();
    }
  }

  Product? get product => _product;
  bool get isLoading => _isLoading || _productProvider.isLoading;
  String get error => _error.isNotEmpty ? _error : _productProvider.error;
  int get selectedImageIndex => _selectedImageIndex;
  int get selectedVariantIndex => _selectedVariantIndex;

  Future<void> _fetchProductDetail() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final fetchedProduct = await _productProvider.getProductById(productId);
      _product = fetchedProduct;
      _error = fetchedProduct == null ? 'Product not found' : '';
    } catch (e) {
      _error = 'Error loading product: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedImageIndex(int index) {
    _selectedImageIndex = index;
    notifyListeners();
  }

  void setSelectedVariantIndex(int index) {
    _selectedVariantIndex = index;
    notifyListeners();
  }

  Future<void> refreshProduct() async {
    return _fetchProductDetail();
  }
} 