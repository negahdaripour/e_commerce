import '../../../infrastructure/commons/dio.dart';
import '../../shared/models/product_view_model.dart';

class UserProductsRepository {
  HttpClient fetcher = HttpClient.dio('http://192.168.7.57:3000/');

  Future<List<ProductViewModel>> getProducts() async {
    final List<dynamic> result = await fetcher.get('product', null);
    final List<ProductViewModel> products = result
        .map((final e) => ProductViewModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return products;
  }
}
