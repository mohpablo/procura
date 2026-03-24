import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUseCase implements UseCase<Product, Map<String, dynamic>> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<Result<Product>> call(Map<String, dynamic> productData) async {
    return await repository.createProduct(productData);
  }
}
