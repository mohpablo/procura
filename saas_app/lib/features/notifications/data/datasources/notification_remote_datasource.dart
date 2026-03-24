import 'package:saas_app/core/api/api_consumer.dart';
import 'package:saas_app/core/api/api_endpoints.dart';
import 'package:saas_app/core/database/secure_storage.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int perPage = 20,
  });
  Future<void> markAsRead(int notificationId);
  Future<void> markAllAsRead();
  Future<int> getUnreadCount();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiConsumer api;
  final SecureStorage secureStorage;

  NotificationRemoteDataSourceImpl(this.api, this.secureStorage);

  @override
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final role = await secureStorage.getUserRole();
      final endpoint = role == 'supplier'
          ? EndPoints.supplierNotifications
          : EndPoints.notifications;

      final response = await api.get(
        endpoint,
        queryParameters: {APIKeys.page: page, APIKeys.perPage: perPage},
        withToken: true,
      );

      final dynamic rawData = response[APIKeys.data];
      final List<dynamic> data;
      if (rawData is List) {
        data = rawData;
      } else if (rawData is Map && rawData.containsKey('data')) {
        data = rawData['data'] is List ? rawData['data'] : [];
      } else {
        data = [];
      }

      return data
          .map(
            (json) => NotificationModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    try {
      final role = await secureStorage.getUserRole();
      final endpoint = role == 'supplier'
          ? EndPoints.supplierMarkNotificationAsRead(notificationId)
          : EndPoints.markNotificationAsRead(notificationId);

      await api.put(endpoint, withToken: true);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      final role = await secureStorage.getUserRole();
      final endpoint = role == 'supplier'
          ? EndPoints.supplierMarkAllNotificationsAsRead
          : EndPoints.markAllNotificationsAsRead;

      await api.post(endpoint, withToken: true);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final role = await secureStorage.getUserRole();
      final endpoint = role == 'supplier'
          ? EndPoints.supplierUnreadNotificationsCount
          : EndPoints.unreadNotificationsCount;

      final response = await api.get(endpoint, withToken: true);
      return response[APIKeys.data][APIKeys.unreadCount] as int;
    } catch (e) {
      rethrow;
    }
  }
}
