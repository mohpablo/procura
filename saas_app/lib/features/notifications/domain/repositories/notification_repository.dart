import 'package:saas_app/core/network/result.dart';
import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<Result<List<Notification>>> getNotifications({
    int page = 1,
    int perPage = 20,
  });
  Future<Result<void>> markAsRead(int notificationId);
  Future<Result<void>> markAllAsRead();
  Future<Result<int>> getUnreadCount();
}
