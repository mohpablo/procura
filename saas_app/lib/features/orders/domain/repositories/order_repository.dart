import 'package:saas_app/core/network/result.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<Result<List<Order>>> getOrders({int page = 1});
  Future<Result<Order>> getOrderById(int id);
  Future<Result<Order>> createOrder(Map<String, dynamic> orderData);
  Future<Result<void>> cancelOrder(int id);
  Future<Result<void>> confirmOrder(int id, String status);
  Future<Result<void>> updateOrderStatus(int id, String status);
}
