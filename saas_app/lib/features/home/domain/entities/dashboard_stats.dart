import 'recent_activity.dart';

class DashboardStats {
  final int totalOrders;
  final double totalRevenue;
  final int pendingOrders;
  final double averageOrderValue;

  const DashboardStats({
    required this.totalOrders,
    required this.totalRevenue,
    required this.pendingOrders,
    required this.averageOrderValue,
  });
}

class BuyerDashboardStats extends DashboardStats {
  final int savedItems;
  final int activeOrders;
  final List<RecentActivity> recentActivities;

  const BuyerDashboardStats({
    required super.totalOrders,
    required super.totalRevenue,
    required super.pendingOrders,
    required super.averageOrderValue,
    required this.savedItems,
    required this.activeOrders,
    this.recentActivities = const [],
  });
}

class SupplierDashboardStats extends DashboardStats {
  final int totalProducts;
  final int lowStockProducts;
  final double rating;

  const SupplierDashboardStats({
    required super.totalOrders,
    required super.totalRevenue,
    required super.pendingOrders,
    required super.averageOrderValue,
    required this.totalProducts,
    required this.lowStockProducts,
    required this.rating,
  });
}
