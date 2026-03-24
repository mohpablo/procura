import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/di/service_locator.dart';
import 'package:saas_app/core/routes/app_routes.dart';

// Auth
import 'package:saas_app/features/auth/presentation/views/sign_in_view.dart';
import 'package:saas_app/features/auth/presentation/views/sign_up_view.dart';
import 'package:saas_app/features/home/presentation/views/buyer_main_view.dart';
import 'package:saas_app/features/home/presentation/views/supplier_main_view.dart';

// Home
import 'package:saas_app/features/home/presentation/views/buyer_dashboard.dart';
import 'package:saas_app/features/home/presentation/views/supplier_dashboard.dart';
import 'package:saas_app/features/home/presentation/views/analytics_view.dart';

// Products
import 'package:saas_app/features/products/presentation/cubit/product_cubit.dart';
import 'package:saas_app/features/products/presentation/views/product_list_view.dart';
import 'package:saas_app/features/products/presentation/views/inventory_view.dart';
import 'package:saas_app/features/products/presentation/views/product_details_view.dart';
import 'package:saas_app/features/products/presentation/views/add_edit_product_view.dart';

// Cart
import 'package:saas_app/features/cart/presentation/views/cart_view.dart';

// Orders
import 'package:saas_app/features/orders/presentation/cubit/order_cubit.dart';
import 'package:saas_app/features/orders/presentation/views/order_list_view.dart';
import 'package:saas_app/features/orders/presentation/views/order_details_view.dart';
import 'package:saas_app/features/orders/presentation/views/checkout_view.dart';

// Notifications
import 'package:saas_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:saas_app/features/notifications/presentation/views/notifications_view.dart';

// Profile
import 'package:saas_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:saas_app/features/profile/presentation/views/profile_view.dart';

// Ratings
import 'package:saas_app/features/ratings/presentation/cubit/rating_cubit.dart';
import 'package:saas_app/features/ratings/presentation/views/ratings_view.dart';

// Entities
import 'package:saas_app/features/auth/domain/entities/user.dart';
import 'package:saas_app/features/products/domain/entities/product.dart';
import 'package:saas_app/features/orders/domain/entities/order.dart';
import 'package:saas_app/features/profile/domain/entities/user_profile.dart';
import 'package:saas_app/features/profile/presentation/views/edit_profile_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // ========== Auth Routes ==========
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const SignInView());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const SignUpView());

      // ========== Buyer Routes ==========
      case AppRoutes.buyerHome:
        if (args is User) {
          return MaterialPageRoute(builder: (_) => BuyerMainView(user: args));
        }
        return _errorRoute();

      case AppRoutes.buyerDashboard:
        if (args is User) {
          return MaterialPageRoute(builder: (_) => BuyerDashboard(user: args));
        }
        return _errorRoute();

      case AppRoutes.products:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ProductCubit>(),
            child: const ProductListView(),
          ),
        );

      case AppRoutes.productDetails:
        if (args is Product) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => sl<ProductCubit>(),
              child: ProductDetailsView(product: args),
            ),
          );
        }
        return _errorRoute();

      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartView());

      case AppRoutes.checkout:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<OrderCubit>(),
            child: const CheckoutView(),
          ),
        );

      case AppRoutes.orders:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<OrderCubit>()..getOrders(),
            child: const OrderListView(),
          ),
        );

      case AppRoutes.orderDetails:
        if (args is Order) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => sl<OrderCubit>(),
              child: OrderDetailsView(order: args),
            ),
          );
        }
        return _errorRoute();

      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<NotificationCubit>()..loadNotifications(),
            child: const NotificationsView(),
          ),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ProfileCubit>(),
            child: const ProfileView(),
          ),
        );

      case AppRoutes.editProfile:
        if (args is UserProfile) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => sl<ProfileCubit>(),
              child: EditProfileView(profile: args),
            ),
          );
        }
        return _errorRoute();

      case AppRoutes.ratings:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<RatingCubit>(),
            child: const RatingsView(),
          ),
        );

      // ========== Supplier Routes ==========
      case AppRoutes.supplierHome:
        if (args is User) {
          return MaterialPageRoute(
            builder: (_) => SupplierMainView(user: args),
          );
        }
        return _errorRoute();

      case AppRoutes.supplierDashboard:
        if (args is User) {
          return MaterialPageRoute(
            builder: (_) => SupplierDashboard(user: args),
          );
        }
        return _errorRoute();

      case AppRoutes.supplierProducts:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ProductCubit>(),
            child: const InventoryView(),
          ),
        );

      case AppRoutes.supplierAddProduct:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ProductCubit>(),
            child: const AddEditProductView(),
          ),
        );

      case AppRoutes.supplierEditProduct:
        if (args is Product) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => sl<ProductCubit>(),
              child: AddEditProductView(product: args),
            ),
          );
        }
        return _errorRoute();

      case AppRoutes.supplierOrders:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<OrderCubit>()..getOrders(),
            child: const OrderListView(),
          ),
        );

      case AppRoutes.supplierAnalytics:
        return MaterialPageRoute(builder: (_) => const AnalyticsView());

      // Default
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
