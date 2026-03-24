import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase
    implements UseCase<List<Notification>, GetNotificationsParams> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Result<List<Notification>>> call(GetNotificationsParams params) {
    return repository.getNotifications(
      page: params.page,
      perPage: params.perPage,
    );
  }
}

class GetNotificationsParams {
  final int page;
  final int perPage;

  GetNotificationsParams({this.page = 1, this.perPage = 20});
}

class MarkAsReadUseCase implements UseCase<void, int> {
  final NotificationRepository repository;

  MarkAsReadUseCase(this.repository);

  @override
  Future<Result<void>> call(int notificationId) {
    return repository.markAsRead(notificationId);
  }
}

class MarkAllAsReadUseCase implements NoParamUseCase<void> {
  final NotificationRepository repository;

  MarkAllAsReadUseCase(this.repository);

  @override
  Future<Result<void>> call() {
    return repository.markAllAsRead();
  }
}

class GetUnreadCountUseCase implements NoParamUseCase<int> {
  final NotificationRepository repository;

  GetUnreadCountUseCase(this.repository);

  @override
  Future<Result<int>> call() {
    return repository.getUnreadCount();
  }
}
