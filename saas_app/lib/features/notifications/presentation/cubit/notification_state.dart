part of 'notification_cubit.dart';

abstract class NotificationState {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationsLoaded extends NotificationState {
  final List<Notification> notifications;

  const NotificationsLoaded(this.notifications);
}

class NotificationEmpty extends NotificationState {
  const NotificationEmpty();
}

class UnreadCountLoaded extends NotificationState {
  final int count;

  const UnreadCountLoaded(this.count);
}

class NotificationError extends NotificationState {
  final String message;
  final String? code;

  const NotificationError(this.message, {this.code});
}
