import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  return Dio(BaseOptions(baseUrl: 'http://localhost:5000'));
}

@riverpod
ApiClient apiClient(Ref ref) {
  final dioInstance = ref.watch(dioProvider);
  return ApiClient(dio: dioInstance);
}

@riverpod
AuthApi authApi(Ref ref) {
  return ref.watch(apiClientProvider).getAuthApi();
}

@riverpod
HealthApi healthApi(Ref ref) {
  return ref.watch(apiClientProvider).getHealthApi();
}
