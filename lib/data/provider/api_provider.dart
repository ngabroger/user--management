import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ApiProvider {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:8000/api/"));
  final box = GetStorage();

  ApiProvider() {
    if (box.hasData('token')) {
      _dio.options.headers["Authorization"] = "Bearer ${box.read('token')}";
    }
  }

  void _setAuthHeader() {
    if (box.hasData('token')) {
      _dio.options.headers["Authorization"] = "Bearer ${box.read('token')}";
    } else {
      _dio.options.headers.remove("Authorization");
    }
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    _setAuthHeader();
    try {
      return await _dio.post(endpoint, data: data);
    } on DioException catch (e) {
      return e.response ??
          Response(
            requestOptions: RequestOptions(path: endpoint),
            statusCode: 500,
            statusMessage: e.message,
            data: {"error": e.message},
          );
    }
  }

  Future<Response> get(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } on DioException catch (e) {
      return e.response ??
          Response(
            requestOptions: RequestOptions(path: endpoint),
            statusCode: 500,
            statusMessage: e.message,
            data: {"error": e.message},
          );
    }
  }

  Future<Response> put(String endpoint, Map<String, dynamic> data) async {
    try {
      return await _dio.put(endpoint, data: data);
    } on DioException catch (e) {
      return e.response ??
          Response(
            requestOptions: RequestOptions(path: endpoint),
            statusCode: 500,
            statusMessage: e.message,
            data: {"error": e.message},
          );
    }
  }

  Future<Response> postMultipart(String endpoint, FormData formData) async {
    try {
      return await _dio.post(endpoint, data: formData);
    } on DioException catch (e) {
      return e.response ??
          Response(
            requestOptions: RequestOptions(path: endpoint),
            statusCode: 500,
            statusMessage: e.message,
            data: {"error": e.message},
          );
    }
  }

  Future<Response> getWithQuery(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    try {
      return await _dio.get(endpoint, queryParameters: query);
    } on DioException catch (e) {
      return e.response ??
          Response(
            requestOptions: RequestOptions(path: endpoint),
            statusCode: 500,
            statusMessage: e.message,
            data: {"error": e.message},
          );
    }
  }
}
