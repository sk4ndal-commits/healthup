import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/core/api/auth_interceptor.dart';
import 'package:mobile_app/core/services/secure_storage_service.dart';

part 'api_provider.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080', // Should be configurable (pointing to Docker API)
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  final storageService = ref.watch(secureStorageServiceProvider);
  dio.interceptors.add(AuthInterceptor(storageService));
  
  // Add logging interceptor in debug mode
  dio.interceptors.add(LogInterceptor(
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
  ));

  return dio;
}

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  final dioClient = ref.watch(dioProvider);
  return ApiClient(dio: dioClient);
}

@riverpod
AuthApi authApi(AuthApiRef ref) {
  final client = ref.watch(apiClientProvider);
  return client.getAuthApi();
}

@riverpod
TodoApi todoApi(TodoApiRef ref) {
  final client = ref.watch(apiClientProvider);
  return client.getTodoApi();
}
