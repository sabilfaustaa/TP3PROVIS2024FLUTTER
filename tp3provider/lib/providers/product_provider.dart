import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final Dio _dio = Dio();

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.get('http://127.0.0.1:8000/products');
      if (response.statusCode == 200) {
        _products = (response.data as List)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        _error = 'Failed to load products';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
