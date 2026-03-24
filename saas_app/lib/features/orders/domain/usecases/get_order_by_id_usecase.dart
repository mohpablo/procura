import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrderByIdUseCase implements UseCase<Order, int> {
  final OrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  @override
  Future<Result<Order>> call(int id) async {
    return await repository.getOrderById(id);
  }
}
