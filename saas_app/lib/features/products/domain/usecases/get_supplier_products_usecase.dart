import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetSupplierProductsUseCase implements UseCase<List<Product>, int> {
  final ProductRepository repository;

  GetSupplierProductsUseCase(this.repository);

  @override
  Future<Result<List<Product>>> call(int supplierId) async {
    return await repository.getSupplierProducts(supplierId);
  }
}
