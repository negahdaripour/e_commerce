import '../../../infrastructure/commons/dio.dart';
import '../../shared/models/user_view_model.dart';

class LoginRepository {
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
}
