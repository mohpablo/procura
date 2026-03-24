import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/notification_cubit.dart';

class NotificationsView extends StatefulWidget {
  static const String routeName = '/buyer/notifications';

  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<NotificationCubit>().loadNotifications(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  actions: [
                    IconButton(
                      onPressed: () =>
                          context.read<NotificationCubit>().markAllAsRead(),
                      icon: const Icon(Icons.done_all_rounded),
                      tooltip: 'Mark all as read',
                    ),
                  ],
                  flexibleSpace: const FlexibleSpaceBar(
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    centerTitle: false,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                if (state is NotificationInitial ||
                    state is NotificationLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is NotificationEmpty)
                  SliverFillRemaining(child: _buildEmptyState())
                else if (state is NotificationsLoaded)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final notification = state.notifications[index];
                        return _buildNotificationCard(context, notification);
                      }, childCount: state.notifications.length),
                    ),
                  )
                else if (state is NotificationError)
                  SliverFillRemaining(
                    child: _buildErrorState(context, state.message),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 64,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you when something important happens.',
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, notification) {
    final isRead = notification.isRead;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead ? Colors.grey.shade100 : const Color(0xFFE2E8F0),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (!isRead) {
            context.read<NotificationCubit>().markAsRead(notification.id);
          }
          if (notification.relatedId != null) {
            _navigateToRelatedContent(context, notification);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getNotificationColor(
                    notification.type,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF6366F1),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: isRead
                            ? const Color(0xFF64748B)
                            : const Color(0xFF334155),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _formatDate(notification.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () =>
                  context.read<NotificationCubit>().loadNotifications(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return Icons.shopping_bag;
      case 'delivery':
        return Icons.local_shipping;
      case 'payment':
        return Icons.payment;
      case 'rating':
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return Colors.blue;
      case 'delivery':
        return Colors.green;
      case 'payment':
        return Colors.orange;
      case 'rating':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }

  void _navigateToRelatedContent(BuildContext context, notification) {
    // Navigate based on notification type
    switch (notification.type.toLowerCase()) {
      case 'order':
        Navigator.pushNamed(
          context,
          '/order-details',
          arguments: notification.relatedId,
        );
        break;
      case 'delivery':
        Navigator.pushNamed(
          context,
          '/order-tracking',
          arguments: notification.relatedId,
        );
        break;
      default:
        break;
    }
  }
}
