import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductByIdUseCase implements UseCase<Product, int> {
  final ProductRepository repository;

  GetProductByIdUseCase(this.repository);

  @override
  Future<Result<Product>> call(int id) async {
    return await repository.getProductById(id);
  }
}
