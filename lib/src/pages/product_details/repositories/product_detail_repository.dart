import '../../../infrastructure/commons/dio.dart';
import '../../shared/models/product_view_model.dart';

class ProductDetailRepository {
  HttpClient fetcher = HttpClient.dio('http://192.168.7.57:3000/');

  Future<ProductViewModel> getProduct(final int id) async {
    final result = await fetcher.get('product/$id', null);
    final ProductViewModel productViewModel = ProductViewModel.fromJson(result);
    return productViewModel;
  }
}
