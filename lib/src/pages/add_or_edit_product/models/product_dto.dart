class ProductDto {
  final String picture;
  final String title;
  final int count;
  final List<String> tags;
  final String description;
  final int price;
  final bool inStock;
  final bool isActive;

  ProductDto(
      {required final this.picture,
      required final this.title,
      required final this.count,
      required final this.tags,
      required final this.description,
      required final this.price,
      required final this.inStock,
      required final this.isActive});

  Map<String, dynamic> toJson() => {
        'picture': picture,
        'title': title,
        'count': count,
        'tags': tags,
        'description': description,
        'price': price,
        'in_stock': inStock,
        'is_active': isActive
      };
}
