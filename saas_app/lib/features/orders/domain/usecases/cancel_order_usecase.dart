import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

class CancelOrderUseCase implements UseCase<void, int> {
  final OrderRepository repository;

  CancelOrderUseCase(this.repository);

  @override
  Future<Result<void>> call(int id) async {
    return await repository.cancelOrder(id);
  }
}
