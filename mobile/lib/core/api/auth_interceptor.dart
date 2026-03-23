import 'package:dio/dio.dart';
import 'package:mobile_app/core/services/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService;

  AuthInterceptor(this._storageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storageService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    final tenantId = await _storageService.getTenantId();
    if (tenantId != null) {
      options.headers['X-Tenant-Id'] = tenantId;
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // TODO: Implement token refresh logic here
    }
    return handler.next(err);
  }
}
