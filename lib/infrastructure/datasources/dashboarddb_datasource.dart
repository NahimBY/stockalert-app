import 'package:dio/dio.dart';
import 'package:stockalert_app/domain/datasources/dashboard_datasource.dart';
import 'package:stockalert_app/domain/entities/dashboard.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/infrastructure/mappers/dashboard_mapper.dart';
import 'package:stockalert_app/infrastructure/models/dashboarddb/dashboard_response.dart';
import 'package:stockalert_app/infrastructure/providers/dio_provider.dart';

class DashboardDatasourceImpl implements DashboardDatasource {
  final Dio dio;

  DashboardDatasourceImpl({Dio? dio}) : dio = dio ?? DioProvider.createDio();

  @override
  Future<Dashboard> obtener({int meses = 6}) async {
    try {
      final response = await dio.get(
        '/dashboard',
        queryParameters: {'meses': meses},
      );
      return DashboardMapper.responseToEntity(
        DashboardResponse.fromJson(
          Map<String, dynamic>.from(response.data),
        ),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
