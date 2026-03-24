import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/errors/app_exceptions.dart';
import 'package:saas_app/features/orders/domain/entities/order.dart';
import 'package:saas_app/features/orders/domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<Order>>> getOrders({int page = 1}) async {
    try {
      final models = await remoteDataSource.getOrders(page: page);
      final orders = models.map((m) => m.toEntity()).toList();
      return Result.success(orders);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to fetch orders: ${e.toString()}');
    }
  }

  @override
  Future<Result<Order>> getOrderById(int id) async {
    try {
      final model = await remoteDataSource.getOrderById(id);
      return Result.success(model.toEntity());
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to fetch order: ${e.toString()}');
    }
  }

  @override
  Future<Result<Order>> createOrder(Map<String, dynamic> orderData) async {
    try {
      final model = await remoteDataSource.createOrder(orderData);
      return Result.success(model.toEntity());
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to create order: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> cancelOrder(int id) async {
    try {
      await remoteDataSource.cancelOrder(id);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to cancel order: ${e.toString()}');
    }
  }
  @override
  Future<Result<void>> confirmOrder(int id, String status) async {
    try {
      await remoteDataSource.confirmOrder(id, status);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to confirm order: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> updateOrderStatus(int id, String status) async {
    try {
      await remoteDataSource.updateOrderStatus(id, status);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to update status: ${e.toString()}');
    }
  }
}
