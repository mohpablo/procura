import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/di/service_locator.dart';
import 'package:saas_app/core/widgets/bottom_nav_bar.dart';
import 'package:saas_app/features/auth/domain/entities/user.dart';

// Import screens
import 'package:saas_app/features/home/presentation/views/supplier_dashboard.dart';
import 'package:saas_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:saas_app/features/products/presentation/cubit/product_cubit.dart';
import 'package:saas_app/features/products/presentation/views/product_list_view.dart';
import 'package:saas_app/features/orders/presentation/cubit/order_cubit.dart';
import 'package:saas_app/features/orders/presentation/views/order_list_view.dart';
import 'package:saas_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:saas_app/features/notifications/presentation/views/notifications_view.dart';
import 'package:saas_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:saas_app/features/profile/presentation/views/profile_view.dart';

class SupplierMainView extends StatefulWidget {
  static const String routeName = '/supplier-main';
  final User user;

  const SupplierMainView({super.key, required this.user});

  @override
  State<SupplierMainView> createState() => _SupplierMainViewState();
}

class _SupplierMainViewState extends State<SupplierMainView> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      BlocProvider(
        create: (_) => sl<HomeCubit>()..loadSupplierDashboard(),
        child: SupplierDashboard(user: widget.user),
      ),
      BlocProvider(
        create: (_) => sl<ProductCubit>()..getProducts(),
        child: const ProductListView(),
      ),
      BlocProvider(
        create: (_) => sl<OrderCubit>()..getOrders(),
        child: const OrderListView(),
      ),
      BlocProvider(
        create: (_) => sl<NotificationCubit>()..loadNotifications(),
        child: const NotificationsView(),
      ),
      BlocProvider(
        create: (_) => sl<ProfileCubit>(),
        child: const ProfileView(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: supplierNavItems,
      ),
    );
  }
}
