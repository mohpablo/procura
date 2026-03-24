import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductParams {
  final int id;
  final Map<String, dynamic> productData;

  UpdateProductParams({required this.id, required this.productData});
}

class UpdateProductUseCase implements UseCase<Product, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<Result<Product>> call(UpdateProductParams params) async {
    return await repository.updateProduct(params.id, params.productData);
  }
}
