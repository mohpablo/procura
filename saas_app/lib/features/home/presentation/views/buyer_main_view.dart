import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/di/service_locator.dart';
import 'package:saas_app/core/widgets/bottom_nav_bar.dart';
import 'package:saas_app/features/auth/domain/entities/user.dart';

// Import screens
import 'package:saas_app/features/home/presentation/views/buyer_dashboard.dart';
import 'package:saas_app/features/products/presentation/cubit/product_cubit.dart';
import 'package:saas_app/features/products/presentation/views/product_list_view.dart';
import 'package:saas_app/features/cart/presentation/views/cart_view.dart';
import 'package:saas_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:saas_app/features/orders/presentation/cubit/order_cubit.dart';
import 'package:saas_app/features/orders/presentation/views/order_list_view.dart';
import 'package:saas_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:saas_app/features/profile/presentation/views/profile_view.dart';

class BuyerMainView extends StatefulWidget {
  static const String routeName = '/buyer-main';
  final User user;

  const BuyerMainView({super.key, required this.user});

  @override
  State<BuyerMainView> createState() => _BuyerMainViewState();
}

class _BuyerMainViewState extends State<BuyerMainView> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      BuyerDashboard(user: widget.user),
      BlocProvider(
        create: (_) => sl<ProductCubit>()..getProducts(),
        child: const ProductListView(),
      ),
      const CartView(),
      BlocProvider(
        create: (_) => sl<OrderCubit>()..getOrders(),
        child: const OrderListView(),
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
          // Refresh cart when switching to cart tab (index 2)
          if (index == 2) {
            context.read<CartCubit>().loadCart();
          }
        },
        items: buyerNavItems,
      ),
    );
  }
}
