import 'package:dio/dio.dart';
import '../models/product.dart';

class ProductRepository {
  final Dio _dio = Dio();

  Future<List<Product>> fetchProducts() async {
    final response = await _dio.get('http://127.0.0.1:8000/products');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> fetchProductDetail(int id) async {
    final response = await _dio.get('http://127.0.0.1:8000/products/$id');
    if (response.statusCode == 200) {
      return Product.fromJson(response.data);
    } else {
      throw Exception('Failed to load product detail');
    }
  }
}
