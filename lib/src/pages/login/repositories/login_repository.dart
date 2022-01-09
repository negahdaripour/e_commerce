import 'package:dartz/dartz.dart';

import '../../../infrastructure/commons/dio.dart';
import '../models/user_view_model.dart';

class LoginRepository {
  HttpClient fetcher = HttpClient.dio('http://192.168.7.57:3000/');

  Future<Either<String, List<UserViewModel>>> getUsers() async {
    try {
      final List<dynamic> result = await fetcher.get('user', null);
      final List<UserViewModel> list = result
          .map((final e) => UserViewModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
