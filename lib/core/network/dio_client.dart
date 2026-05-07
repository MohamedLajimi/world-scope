import 'package:dio/dio.dart';

class DioClient {
  DioClient._();

  static final Dio instance = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
}
