import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/errors/app_exceptions.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<Notification>>> getNotifications({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final models = await remoteDataSource.getNotifications(
        page: page,
        perPage: perPage,
      );
      final notifications = models.map((model) => model.toEntity()).toList();
      return Result.success(notifications);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to fetch notifications: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> markAsRead(int notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure(
        'Failed to mark notification as read: ${e.toString()}',
      );
    }
  }

  @override
  Future<Result<void>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure(
        'Failed to mark all notifications as read: ${e.toString()}',
      );
    }
  }

  @override
  Future<Result<int>> getUnreadCount() async {
    try {
      final count = await remoteDataSource.getUnreadCount();
      return Result.success(count);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to get unread count: ${e.toString()}');
    }
  }
}
