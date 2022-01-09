import 'cart_item_view_model.dart';

class UserViewModel {
  final int id;
  final String picture;
  final String firstname;
  final String lastname;
  final String username;
  final String password;
  final String address;
  final bool isAdmin;
  final List<int> favourites;
  final List<CartItemViewModel> cart;

  UserViewModel(
      {required final this.id,
      required final this.picture,
      required final this.firstname,
      required final this.lastname,
      required final this.username,
      required final this.password,
      required final this.address,
      required final this.isAdmin,
      required final this.favourites,
      required final this.cart});

  factory UserViewModel.fromJson(final Map<String, dynamic> json) {
    final List<Map<String, dynamic>> list = [];
    for (final item in json['cart']) {
      list.add(item as Map<String, dynamic>);
    }
    final List<CartItemViewModel> cartItems =
        list.map(CartItemViewModel.fromJson).toList();

    final List<int> favouriteInts = [];
    for (final item in json['favourites']) {
      favouriteInts.add(item as int);
    }

    return UserViewModel(
        id: json['id'],
        picture: json['picture'],
        firstname: json['first_name'],
        lastname: json['last_name'],
        username: json['username'],
        password: json['password'],
        address: json['address'],
        isAdmin: json['is_admin'],
        favourites: favouriteInts,
        cart: cartItems);
  }

  UserViewModel copyWith({
    final int? id,
    final String? picture,
    final String? firstname,
    final String? lastname,
    final String? username,
    final String? password,
    final String? address,
    final bool? isAdmin,
    final List<int>? favourites,
    final List<CartItemViewModel>? cart,
  }) =>
      UserViewModel(
          id: id ?? this.id,
          picture: picture ?? this.picture,
          firstname: firstname ?? this.firstname,
          lastname: lastname ?? this.lastname,
          username: username ?? this.username,
          password: password ?? this.password,
          address: address ?? this.address,
          isAdmin: isAdmin ?? this.isAdmin,
          favourites: favourites ?? this.favourites,
          cart: cart ?? this.cart);

  @override
  String toString() =>
      'UserViewModel{id: $id, firstname: $firstname, lastname: $lastname,'
      ' username: $username, password: $password, address: $address,'
      ' isAdmin: $isAdmin, favourites: $favourites, cart: $cart}';
}
