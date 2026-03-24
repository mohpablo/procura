import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification.dart';
import '../../domain/usecases/notification_usecases.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final MarkAllAsReadUseCase markAllAsReadUseCase;
  final GetUnreadCountUseCase getUnreadCountUseCase;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markAsReadUseCase,
    required this.markAllAsReadUseCase,
    required this.getUnreadCountUseCase,
  }) : super(const NotificationInitial());

  Future<void> loadNotifications({int page = 1}) async {
    emit(const NotificationLoading());

    final result = await getNotificationsUseCase(
      GetNotificationsParams(page: page),
    );

    result.when(
      onSuccess: (notifications) {
        if (notifications.isEmpty) {
          emit(const NotificationEmpty());
        } else {
          emit(NotificationsLoaded(notifications));
        }
      },
      onFailure: (message, code) {
        emit(NotificationError(message, code: code));
      },
    );
  }

  Future<void> markAsRead(int notificationId) async {
    final result = await markAsReadUseCase(notificationId);

    result.when(
      onSuccess: (_) {
        loadNotifications();
      },
      onFailure: (message, code) {
        emit(NotificationError(message, code: code));
      },
    );
  }

  Future<void> markAllAsRead() async {
    final result = await markAllAsReadUseCase();

    result.when(
      onSuccess: (_) {
        loadNotifications();
      },
      onFailure: (message, code) {
        emit(NotificationError(message, code: code));
      },
    );
  }

  Future<void> loadUnreadCount() async {
    final result = await getUnreadCountUseCase();

    result.when(
      onSuccess: (count) {
        emit(UnreadCountLoaded(count));
      },
      onFailure: (message, code) {
        // Silently fail for unread count
      },
    );
  }

  void refresh() {
    loadNotifications();
  }
}
