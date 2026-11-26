import 'package:stockalert_app/domain/datasources/categorias_datasource.dart';
import 'package:stockalert_app/domain/repositories/categorias_repository.dart';

class CategoriasRepositoryImpl implements CategoriasRepository {
  final CategoriasDatasource datasource;

  CategoriasRepositoryImpl(this.datasource);

  @override
  Future<List<String>> listar() => datasource.listar();
}
