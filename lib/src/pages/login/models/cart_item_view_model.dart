class CartItemViewModel {
  final int productId;
  final int count;

  CartItemViewModel({
    required final this.productId,
    required final this.count,
  });

  factory CartItemViewModel.fromJson(final Map<String, dynamic> json) =>
      CartItemViewModel(productId: json['product_id'], count: json['count']);
}
