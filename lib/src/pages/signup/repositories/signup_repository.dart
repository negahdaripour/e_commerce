import '../../../infrastructure/commons/dio.dart';
import '../models/user_dto.dart';
import '../models/user_view_model.dart';

class SignupRepository {
  HttpClient fetcher = HttpClient.dio('http://192.168.7.57:3000/');

  Future<List<UserViewModel>> getUsers() async {
    final List<dynamic> result = await fetcher.get('user', null);
    final List<UserViewModel> list = result
        .map((final e) => UserViewModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  Future<void> addUser(final UserDto user) async {
    await fetcher.post('user', user.toJson());
  }
}
