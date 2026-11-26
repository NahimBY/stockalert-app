import 'package:dio/dio.dart';
import 'package:stockalert_app/domain/datasources/categorias_datasource.dart';
import 'package:stockalert_app/infrastructure/errors/api_error.dart';
import 'package:stockalert_app/infrastructure/providers/dio_provider.dart';

class CategoriasDatasourceImpl implements CategoriasDatasource {
  final Dio dio;

  CategoriasDatasourceImpl({Dio? dio}) : dio = dio ?? DioProvider.createDio();

  @override
  Future<List<String>> listar() async {
    try {
      final response = await dio.get('/categorias');
      return (response.data as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
