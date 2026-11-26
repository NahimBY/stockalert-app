import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      String message = 'Error en la respuesta del servidor';
      if (data is Map && data['error'] is String) {
        message = data['error'] as String;
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }
      return ApiException(message, statusCode: e.response!.statusCode);
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException('El servidor está tardando en responder');
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiException('Tiempo de espera agotado');
      case DioExceptionType.connectionError:
        return ApiException(
          'Error de conexión. Verifica tu conexión a internet',
        );
      case DioExceptionType.cancel:
        return ApiException('La solicitud fue cancelada');
      default:
        return ApiException('Error inesperado: ${e.message}');
    }
  }

  @override
  String toString() => message;
}
