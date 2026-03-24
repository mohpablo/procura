import 'package:saas_app/core/api/api_consumer.dart';
import 'package:saas_app/core/api/api_endpoints.dart';
import 'package:saas_app/core/database/secure_storage.dart';
import 'package:saas_app/core/errors/app_exceptions.dart';
import '../models/order_model.dart';

class OrderRemoteDataSource {
  final ApiConsumer api;
  final SecureStorage secureStorage;

  OrderRemoteDataSource(this.api, this.secureStorage);

  Future<List<OrderModel>> getOrders({int page = 1}) async {
    try {
      final role = await secureStorage.getUserRole();
      final endpoint = role == 'supplier'
          ? EndPoints.supplierOrders
          : EndPoints.orders;

      final response = await api.get(
        endpoint,
        queryParameters: {APIKeys.page: page},
        withToken: true,
      );

      final dynamic rawData = response[APIKeys.data];
      final List<dynamic> orderList;
      if (rawData is List) {
        orderList = rawData;
      } else if (rawData is Map && rawData.containsKey('data')) {
        orderList = rawData['data'] is List ? rawData['data'] : [];
      } else {
        orderList = [];
      }

      return orderList
          .map((o) => OrderModel.fromJson(o as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderModel> getOrderById(int id) async {
    try {
      final response = await api.get(
        EndPoints.orderDetails(id),
        withToken: true,
      );
      return OrderModel.fromJson(response[APIKeys.data]);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await api.post(
        EndPoints.checkout,
        body: orderData,
        withToken: true,
      );

      final dynamic rawData = response[APIKeys.data];

      if (rawData is List && rawData.isNotEmpty) {
        return OrderModel.fromJson(rawData[0] as Map<String, dynamic>);
      } else if (rawData is Map<String, dynamic>) {
        return OrderModel.fromJson(rawData);
      } else {
        throw ServerException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelOrder(int id) async {
    try {
      await api.post(EndPoints.cancelOrder(id), withToken: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmOrder(int id, String status) async {
    try {
      await api.post(
        EndPoints.confirmOrder(id),
        body: {APIKeys.status: status},
        withToken: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrderStatus(int id, String status) async {
    try {
      if (status == 'preparing') {
        await api.post(EndPoints.markStartPreparing(id), withToken: true);
      } else if (status == 'ready_for_delivery') {
        await api.post(EndPoints.markReadyForDelivery(id), withToken: true);
      } else {
        await api.put(
          EndPoints.updateOrderStatus(id),
          body: {APIKeys.status: status},
          withToken: true,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
