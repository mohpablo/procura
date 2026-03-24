import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrdersParams {
  final int page;
  const GetOrdersParams({this.page = 1});
}

class GetOrdersUseCase implements UseCase<List<Order>, GetOrdersParams> {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  @override
  Future<Result<List<Order>>> call(GetOrdersParams params) {
    return repository.getOrders(page: params.page);
  }
}

class GetOrderByIdUseCase implements UseCase<Order, int> {
  final OrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  @override
  Future<Result<Order>> call(int orderId) {
    return repository.getOrderById(orderId);
  }
}

class CreateOrderUseCase implements UseCase<Order, Map<String, dynamic>> {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Result<Order>> call(Map<String, dynamic> orderData) {
    return repository.createOrder(orderData);
  }
}

class CancelOrderUseCase implements UseCase<void, int> {
  final OrderRepository repository;

  CancelOrderUseCase(this.repository);

  @override
  Future<Result<void>> call(int orderId) {
    return repository.cancelOrder(orderId);
  }
}

class ConfirmOrderParams {
  final int orderId;
  final String status;
  const ConfirmOrderParams({required this.orderId, required this.status});
}

class ConfirmOrderUseCase implements UseCase<void, ConfirmOrderParams> {
  final OrderRepository repository;

  ConfirmOrderUseCase(this.repository);

  @override
  Future<Result<void>> call(ConfirmOrderParams params) {
    return repository.confirmOrder(params.orderId, params.status);
  }
}

class UpdateOrderStatusUseCase implements UseCase<void, ConfirmOrderParams> {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  @override
  Future<Result<void>> call(ConfirmOrderParams params) {
    return repository.updateOrderStatus(params.orderId, params.status);
  }
}
