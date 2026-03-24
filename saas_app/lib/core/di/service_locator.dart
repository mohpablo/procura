import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:saas_app/core/api/api_consumer.dart';
import 'package:saas_app/core/api/dio_consumer.dart';
import 'package:saas_app/core/database/secure_storage.dart';

// Home
import 'package:saas_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:saas_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:saas_app/features/home/domain/repositories/home_repository.dart';
import 'package:saas_app/features/home/domain/usecases/home_usecases.dart';
import 'package:saas_app/features/home/presentation/cubit/home_cubit.dart';

// Auth
import 'package:saas_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:saas_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:saas_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:saas_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:saas_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:saas_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:saas_app/features/auth/presentation/cubit/auth_cubit.dart';

// Products
import 'package:saas_app/features/products/data/datasources/product_remote_datasource.dart';
import 'package:saas_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:saas_app/features/products/domain/repositories/product_repository.dart';
import 'package:saas_app/features/products/domain/usecases/product_usecases.dart';
import 'package:saas_app/features/products/presentation/cubit/product_cubit.dart';

// Cart
import 'package:saas_app/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:saas_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:saas_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:saas_app/features/cart/domain/usecases/cart_usecases.dart';
import 'package:saas_app/features/cart/presentation/cubit/cart_cubit.dart';

// Orders
import 'package:saas_app/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:saas_app/features/orders/data/repositories/order_repository_impl.dart';
import 'package:saas_app/features/orders/domain/repositories/order_repository.dart';
import 'package:saas_app/features/orders/domain/usecases/order_usecases.dart';
import 'package:saas_app/features/orders/presentation/cubit/order_cubit.dart';

// Notifications
import 'package:saas_app/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:saas_app/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:saas_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:saas_app/features/notifications/domain/usecases/notification_usecases.dart';
import 'package:saas_app/features/notifications/presentation/cubit/notification_cubit.dart';

// Profile
import 'package:saas_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:saas_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:saas_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:saas_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:saas_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:saas_app/features/profile/presentation/cubit/profile_cubit.dart';

// Ratings
import 'package:saas_app/features/ratings/data/datasources/rating_remote_datasource.dart';
import 'package:saas_app/features/ratings/data/repositories/rating_repository_impl.dart';
import 'package:saas_app/features/ratings/domain/repositories/rating_repository.dart';
import 'package:saas_app/features/ratings/domain/usecases/get_available_ratings_usecase.dart';
import 'package:saas_app/features/ratings/domain/usecases/submit_rating_usecase.dart';
import 'package:saas_app/features/ratings/presentation/cubit/rating_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ========== Core ==========
  // Dio
  sl.registerLazySingleton<Dio>(() => Dio());

  // API Consumer
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(sl()));

  // Secure Storage
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());

  // ========== Auth Feature ==========
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => AuthCubit(loginUseCase: sl(), registerUseCase: sl()),
  );

  // ========== Products Feature ==========
  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(sl()));
  sl.registerLazySingleton(() => CreateProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerLazySingleton(() => GetSupplierProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => ProductCubit(
      getProductsUseCase: sl(),
      getProductByIdUseCase: sl(),
      searchProductsUseCase: sl(),
      createProductUseCase: sl(),
      updateProductUseCase: sl(),
      deleteProductUseCase: sl(),
      getSupplierProductsUseCase: sl(),
      getCategoriesUseCase: sl(),
    ),
  );

  // ========== Cart Feature ==========
  // Data sources
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartItemUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));

  // Cubits
  sl.registerLazySingleton(
    () => CartCubit(
      getCartUseCase: sl(),
      addToCartUseCase: sl(),
      updateCartItemUseCase: sl(),
      removeFromCartUseCase: sl(),
      clearCartUseCase: sl(),
    ),
  );

  // ========== Orders Feature ==========
  // Data sources
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSource(sl(), sl()),
  );

  // Repositories
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateOrderUseCase(sl()));
  sl.registerLazySingleton(() => CancelOrderUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmOrderUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOrderStatusUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => OrderCubit(
      getOrdersUseCase: sl(),
      getOrderByIdUseCase: sl(),
      createOrderUseCase: sl(),
      cancelOrderUseCase: sl(),
      confirmOrderUseCase: sl(),
      updateOrderStatusUseCase: sl(),
    ),
  );

  // ========== Notifications Feature ==========
  // Data sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl(), sl()),
  );

  // Repositories
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllAsReadUseCase(sl()));
  sl.registerLazySingleton(() => GetUnreadCountUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => NotificationCubit(
      getNotificationsUseCase: sl(),
      markAsReadUseCase: sl(),
      markAllAsReadUseCase: sl(),
      getUnreadCountUseCase: sl(),
    ),
  );

  // ========== Profile Feature ==========
  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl(), sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => ProfileCubit(getProfileUseCase: sl(), updateProfileUseCase: sl()),
  );

  // ========== Ratings Feature ==========
  // Data sources
  sl.registerLazySingleton<RatingRemoteDataSource>(
    () => RatingRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<RatingRepository>(() => RatingRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAvailableRatingsUseCase(sl()));
  sl.registerLazySingleton(() => SubmitRatingUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => RatingCubit(
      getAvailableRatingsUseCase: sl(),
      submitRatingUseCase: sl(),
    ),
  );

  // ========== Home Feature ==========
  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetBuyerDashboardStatsUseCase(sl()));
  sl.registerLazySingleton(() => GetSupplierDashboardStatsUseCase(sl()));

  // Cubits
  sl.registerLazySingleton(
    () => HomeCubit(
      getBuyerDashboardStatsUseCase: sl(),
      getSupplierDashboardStatsUseCase: sl(),
      getOrdersUseCase: sl(),
      getNotificationsUseCase: sl(),
    ),
  );
}
