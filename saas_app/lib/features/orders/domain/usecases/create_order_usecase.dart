import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase implements UseCase<Order, Map<String, dynamic>> {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Result<Order>> call(Map<String, dynamic> orderData) async {
    return await repository.createOrder(orderData);
  }
}
