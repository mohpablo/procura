import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProductsUseCase implements UseCase<List<Product>, String> {
  final ProductRepository repository;

  SearchProductsUseCase(this.repository);

  @override
  Future<Result<List<Product>>> call(String query) async {
    return await repository.searchProducts(query);
  }
}
