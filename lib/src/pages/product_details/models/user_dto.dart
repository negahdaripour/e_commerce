import 'cart_item_view_model.dart';

class UserDto {
  final String picture;
  final String firstname;
  final String lastname;
  final String username;
  final String password;
  final String address;
  final bool isAdmin;
  final List<int> favourites;
  final List<CartItemViewModel> cart;

  UserDto({
    required final this.picture,
    required final this.firstname,
    required final this.lastname,
    required final this.username,
    required final this.password,
    required final this.address,
    required final this.isAdmin,
    required final this.favourites,
    required final this.cart,
  });

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> userCart =
        cart.map((final e) => e.toJson()).toList();
    return {
      'picture': picture,
      'first_name': firstname,
      'last_name': lastname,
      'username': username,
      'password': password,
      'address': address,
      'is_admin': isAdmin,
      'favourites': favourites,
      'cart': userCart
    };
  }
}
