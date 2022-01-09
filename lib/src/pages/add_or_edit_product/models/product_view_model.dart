class ProductViewModel {
  final int id;
  final String picture;
  final String title;
  final int count;
  final List<String> tags;
  final String description;
  final int price;
  final bool inStock;
  final bool isActive;

  ProductViewModel(
      {required final this.id,
      required final this.picture,
      required final this.title,
      required final this.count,
      required final this.tags,
      required final this.description,
      required final this.price,
      required final this.inStock,
      required final this.isActive});

  factory ProductViewModel.fromJson(final Map<String, dynamic> json) {
    final List<String> tags = [];
    for (final item in json['tags']) {
      tags.add(item as String);
    }
    return ProductViewModel(
        id: json['id'],
        picture: json['picture'],
        title: json['title'],
        count: json['count'],
        tags: tags,
        description: json['description'],
        price: json['price'],
        inStock: json['in_stock'],
        isActive: json['is_active']);
  }
}
