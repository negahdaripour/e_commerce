import '../../../infrastructure/commons/dio.dart';
import '../models/product_view_model.dart';

class SearchProductRepository {
  HttpClient fetcher = HttpClient.dio('http://192.168.7.57:3000/');

  Future<List<ProductViewModel>> searchProducts(
      final String searchString) async {
    final List<dynamic> result =
        await fetcher.get('product?q=$searchString', null);
    final List<ProductViewModel> products = result
        .map((final e) => ProductViewModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return products;
  }

  Future<void> deleteUProduct(final int id) async {
    await fetcher.delete('product/$id', null);
  }
}
