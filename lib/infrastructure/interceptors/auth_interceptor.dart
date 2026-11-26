import 'package:dio/dio.dart';
import 'package:stockalert_app/infrastructure/services/refresh_token_service.dart';

class AuthInterceptor extends Interceptor {
  final RefreshTokenService refreshService;
  final bool handleRefresh;
  final _excludedPaths = [
    '/auth/login',
    '/auth/registro',
    '/auth/refresh',
    '/auth/logout',
  ];

  AuthInterceptor({
    required this.refreshService,
    this.handleRefresh = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_excludedPaths.contains(options.path)) {
      final token = refreshService.accessToken;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!handleRefresh) return handler.next(err);

    if (err.response?.statusCode == 401 &&
        !_excludedPaths.contains(err.requestOptions.path)) {
      try {
        final newToken = await refreshService.refreshAccessToken();
        if (newToken != null) {
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';

          final response = await Dio().fetch(opts);
          return handler.resolve(response);
        }
      } catch (_) {
        // Si la renovación falla se propaga el 401 original.
      }
    }
    return handler.next(err);
  }
}
