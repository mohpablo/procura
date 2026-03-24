import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/features/home/domain/entities/dashboard_stats.dart';
import 'package:saas_app/features/home/domain/entities/recent_activity.dart';
import 'package:saas_app/features/home/domain/usecases/home_usecases.dart';
import 'package:saas_app/features/orders/domain/usecases/order_usecases.dart';
import 'package:saas_app/features/notifications/domain/usecases/notification_usecases.dart';
import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/features/orders/domain/entities/order.dart';
import 'package:saas_app/features/notifications/domain/entities/notification.dart' as app_notif;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetBuyerDashboardStatsUseCase getBuyerDashboardStatsUseCase;
  final GetSupplierDashboardStatsUseCase getSupplierDashboardStatsUseCase;
  final GetOrdersUseCase getOrdersUseCase;
  final GetNotificationsUseCase getNotificationsUseCase;

  HomeCubit({
    required this.getBuyerDashboardStatsUseCase,
    required this.getSupplierDashboardStatsUseCase,
    required this.getOrdersUseCase,
    required this.getNotificationsUseCase,
  }) : super(const HomeInitial());

  Future<void> loadBuyerDashboard() async {
    emit(const HomeLoading());

    // Run APIs concurrently to avoid sequential hang
    final results = await Future.wait([
      getBuyerDashboardStatsUseCase(),
      getOrdersUseCase(GetOrdersParams(page: 1)),
      getNotificationsUseCase(GetNotificationsParams(page: 1, perPage: 10)),
    ]);

    final statsResult = results[0] as Result<BuyerDashboardStats>;
    final ordersResult = results[1] as Result<List<Order>>;
    final notificationsResult = results[2] as Result<List<app_notif.Notification>>;

    statsResult.when(
      onSuccess: (stats) {
        final List<RecentActivity> activities = [];

        ordersResult.when(
          onSuccess: (orders) {
            activities.addAll(
              orders.take(5).map(
                    (order) => RecentActivity(
                      id: 'order_${order.id}',
                      title: 'Order #${order.id}',
                      description: 'Status: ${order.status.name}',
                      dateTime: order.createdAt,
                      type: 'order',
                      icon: Icons.shopping_bag_outlined,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
            );
          },
          onFailure: (_, __) {},
        );

        notificationsResult.when(
          onSuccess: (notifications) {
            activities.addAll(
              notifications.take(5).map(
                    (notification) => RecentActivity(
                      id: 'notification_${notification.id}',
                      title: notification.title,
                      description: notification.message,
                      dateTime: notification.createdAt,
                      type: 'notification',
                      icon: Icons.notifications_none_rounded,
                      color: const Color(0xFF10B981),
                    ),
                  ),
            );
          },
          onFailure: (_, __) {},
        );

        activities.sort((a, b) => b.dateTime.compareTo(a.dateTime));

        final processedStats = BuyerDashboardStats(
          totalOrders: stats.totalOrders,
          totalRevenue: stats.totalRevenue,
          pendingOrders: stats.pendingOrders,
          averageOrderValue: stats.averageOrderValue,
          savedItems: stats.savedItems,
          activeOrders: stats.activeOrders,
          recentActivities: activities.take(10).toList(),
        );

        emit(BuyerDashboardLoaded(processedStats));
      },
      onFailure: (message, code) {
        emit(HomeError(message, code: code));
      },
    );
  }

  Future<void> loadSupplierDashboard() async {
    emit(const HomeLoading());

    final result = await getSupplierDashboardStatsUseCase();

    result.when(
      onSuccess: (stats) {
        emit(SupplierDashboardLoaded(stats));
      },
      onFailure: (message, code) {
        emit(HomeError(message, code: code));
      },
    );
  }

  void refresh() {
    final currentState = state;
    if (currentState is BuyerDashboardLoaded) {
      loadBuyerDashboard();
    } else if (currentState is SupplierDashboardLoaded) {
      loadSupplierDashboard();
    }
  }
}
