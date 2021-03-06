import '../../../infrastructure/commons/dio.dart';
import '../models/product_dto.dart';
import '../models/product_view_model.dart';

class AddOrEditRepository {
  HttpClient fetcher = HttpClient.dio('http://192.168.7.57:3000/');

  Future<ProductViewModel> getProduct(final int id) async {
    final result = await fetcher.get('product/$id', null);
    final ProductViewModel productViewModel = ProductViewModel.fromJson(result);
    return productViewModel;
  }

  Future<List<ProductViewModel>> getProducts() async {
    final List<dynamic> result = await fetcher.get('product', null);
    final List<ProductViewModel> products = result
        .map((final e) => ProductViewModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return products;
  }

  Future<void> addProduct(final ProductDto product) async {
    await fetcher.post('product', product.toJson());
  }

  Future<void> editProduct(final int id, final ProductDto product) async {
    await fetcher.put('product/$id', product.toJson());
  }
}
