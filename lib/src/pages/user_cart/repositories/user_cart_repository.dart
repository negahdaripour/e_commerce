import '../../../infrastructure/commons/dio.dart';
import '../models/user_dto.dart';
import '../models/user_view_model.dart';

class UserCartRepository {
  HttpClient fetcher = HttpClient.dio('http://192.168.7.57:3000/');

  Future<UserViewModel> getUser(final int id) async {
    final result = await fetcher.get('user/$id', null);
    final UserViewModel userViewModel = UserViewModel.fromJson(result);
    return userViewModel;
  }

  Future<void> editUser(final int id, final UserDto user) async {
    await fetcher.put('user/$id', user.toJson());
  }
}
