import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProductUseCase implements UseCase<void, int> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<Result<void>> call(int id) async {
    return await repository.deleteProduct(id);
  }
}
