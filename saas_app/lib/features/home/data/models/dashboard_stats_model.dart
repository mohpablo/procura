import 'package:saas_app/features/home/domain/entities/dashboard_stats.dart';
import 'package:saas_app/core/utils/json_utils.dart';

class DashboardStatsModel {
  final int totalOrders;
  final double totalRevenue;
  final int pendingOrders;
  final double averageOrderValue;

  DashboardStatsModel({
    required this.totalOrders,
    required this.totalRevenue,
    required this.pendingOrders,
    required this.averageOrderValue,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalOrders: JsonUtils.parseInt(json['total_orders']),
      totalRevenue: JsonUtils.parseDouble(json['total_revenue']),
      pendingOrders: JsonUtils.parseInt(json['pending_orders']),
      averageOrderValue: JsonUtils.parseDouble(json['average_order_value']),
    );
  }

  Map<String, dynamic> toJson() => {
    'total_orders': totalOrders,
    'total_revenue': totalRevenue,
    'pending_orders': pendingOrders,
    'average_order_value': averageOrderValue,
  };
}

class BuyerDashboardStatsModel extends DashboardStatsModel {
  final int savedItems;
  final int activeOrders;

  BuyerDashboardStatsModel({
    required super.totalOrders,
    required super.totalRevenue,
    required super.pendingOrders,
    required super.averageOrderValue,
    required this.savedItems,
    required this.activeOrders,
  });

  factory BuyerDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return BuyerDashboardStatsModel(
      totalOrders: JsonUtils.parseInt(json['total_orders']),
      totalRevenue: JsonUtils.parseDouble(json['total_revenue']),
      pendingOrders: JsonUtils.parseInt(json['pending_orders']),
      averageOrderValue: JsonUtils.parseDouble(json['average_order_value']),
      savedItems: JsonUtils.parseInt(json['saved_items']),
      activeOrders: JsonUtils.parseInt(json['active_orders']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'saved_items': savedItems,
    'active_orders': activeOrders,
  };

  BuyerDashboardStats toEntity() {
    return BuyerDashboardStats(
      totalOrders: totalOrders,
      totalRevenue: totalRevenue,
      pendingOrders: pendingOrders,
      averageOrderValue: averageOrderValue,
      savedItems: savedItems,
      activeOrders: activeOrders,
      recentActivities: [], // TODO: Parse from JSON if available
    );
  }
}

class SupplierDashboardStatsModel extends DashboardStatsModel {
  final int totalProducts;
  final int lowStockProducts;
  final double rating;

  SupplierDashboardStatsModel({
    required super.totalOrders,
    required super.totalRevenue,
    required super.pendingOrders,
    required super.averageOrderValue,
    required this.totalProducts,
    required this.lowStockProducts,
    required this.rating,
  });

  factory SupplierDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return SupplierDashboardStatsModel(
      totalOrders: JsonUtils.parseInt(json['total_orders']),
      totalRevenue: JsonUtils.parseDouble(json['total_revenue']),
      pendingOrders: JsonUtils.parseInt(json['pending_orders']),
      averageOrderValue: JsonUtils.parseDouble(json['average_order_value']),
      totalProducts: JsonUtils.parseInt(json['total_products']),
      lowStockProducts: JsonUtils.parseInt(json['low_stock_products']),
      rating: JsonUtils.parseDouble(json['rating']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'total_products': totalProducts,
    'low_stock_products': lowStockProducts,
    'rating': rating,
  };

  SupplierDashboardStats toEntity() {
    return SupplierDashboardStats(
      totalOrders: totalOrders,
      totalRevenue: totalRevenue,
      pendingOrders: pendingOrders,
      averageOrderValue: averageOrderValue,
      totalProducts: totalProducts,
      lowStockProducts: lowStockProducts,
      rating: rating,
    );
  }
}
