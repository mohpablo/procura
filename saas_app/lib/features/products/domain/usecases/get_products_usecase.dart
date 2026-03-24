import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsParams {
  final int page;
  final String? category;
  final String? searchQuery;

  GetProductsParams({
    required this.page,
    this.category,
    this.searchQuery,
  });
}

class GetProductsUseCase implements UseCase<List<Product>, GetProductsParams> {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Result<List<Product>>> call(GetProductsParams params) async {
    return await repository.getProducts(
      page: params.page,
      category: params.category,
      searchQuery: params.searchQuery,
    );
  }
}
