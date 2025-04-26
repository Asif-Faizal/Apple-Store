import 'package:flutter/foundation.dart';
import '../models/product.model.dart';

class SearchFilterProvider with ChangeNotifier {
  String _searchQuery = '';
  String? _selectedType;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  String get searchQuery => _searchQuery;
  String? get selectedType => _selectedType;
  List<Product> get filteredProducts => _filteredProducts;

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setSelectedType(String? type) {
    _selectedType = type;
    _applyFilters();
  }

  void filterProducts(List<Product> products) {
    _allProducts = products;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == null || product.type == _selectedType;
      return matchesSearch && matchesType;
    }).toList();
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedType = null;
    _applyFilters();
  }
}