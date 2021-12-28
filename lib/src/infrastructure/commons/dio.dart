import 'dart:async';

import 'package:dio/dio.dart';

abstract class HttpClient {
  final String baseUrl;

  Future<dynamic> get(
      final String endPoint, final Map<String, dynamic>? queryParameters);

  Future<dynamic> post(final String endPoint, final dynamic data);

  Future<dynamic> delete(final String endPoint, final dynamic data);

  Future<dynamic> put(final String endPoint, final dynamic data);

  HttpClient(this.baseUrl);

  factory HttpClient.dio(final String baseUrl) => FetchJsonDio(baseUrl);
}

class FetchJsonDio extends HttpClient {
  Dio dio = Dio();

  FetchJsonDio(final String baseUrl) : super(baseUrl);

  @override
  Future delete(final String endPoint, final dynamic data) async {
    final response = await dio.delete('$baseUrl$endPoint', data: data);
    return response.data;
  }

  @override
  Future get(final String endPoint, final dynamic queryParameters) async {
    final response =
        await dio.get('$baseUrl$endPoint', queryParameters: queryParameters);
    return response.data;
  }

  @override
  Future post(final String endPoint, final dynamic data) async {
    final response = await dio.post('$baseUrl$endPoint', data: data);
    return response.data;
  }

  @override
  Future put(final String endPoint, final dynamic data) async {
    final response = await dio.put('$baseUrl$endPoint', data: data);
    return response.data;
  }
}
