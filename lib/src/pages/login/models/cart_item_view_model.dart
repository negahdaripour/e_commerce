class CartItemViewModel {
  final int productId;
  final int count;

  CartItemViewModel({
    required final this.productId,
    required final this.count,
  });

  factory CartItemViewModel.fromJson(final Map<String, dynamic> json) =>
      CartItemViewModel(productId: json['product_id'], count: json['count']);

  CartItemViewModel copyWith({
    final int? productId,
    final int? count,
  }) =>
      CartItemViewModel(
          productId: productId ?? this.productId, count: count ?? this.count);

  Map<String, dynamic> toJson() => {'product_id': productId, 'count': count};

  @override
  String toString() =>
      'CartItemViewModel{productId: $productId, count: $count}';
}
