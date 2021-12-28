import '../../../infrastructure/commons/dio.dart';
import '../models/user_dto.dart';
import '../models/user_view_model.dart';

class UserRepository {
  HttpClient fetcher = HttpClient.dio('http://192.168.7.57:3000/');

  Future<UserViewModel> getUser(final int id) async {
    final result = await fetcher.get('user/$id', null);
    final UserViewModel userViewModel = UserViewModel.fromJson(result);
    return userViewModel;
  }

  Future<List<UserViewModel>> getUsers() async {
    final List<dynamic> result = await fetcher.get('user', null);
    final List<UserViewModel> list = result
        .map((final e) => UserViewModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  Future<void> deleteUser(final int id) async {
    await fetcher.delete('user/$id', null);
  }

  Future<void> editUser(final int id, final UserDto user) async {
    await fetcher.put('user/$id', user.toJson());
  }

  Future<void> addUser(final UserDto user) async {
    await fetcher.post('user', user.toJson());
  }
}
