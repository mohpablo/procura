part of 'home_cubit.dart';

sealed class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class BuyerDashboardLoaded extends HomeState {
  final BuyerDashboardStats stats;

  const BuyerDashboardLoaded(this.stats);
}

class SupplierDashboardLoaded extends HomeState {
  final SupplierDashboardStats stats;

  const SupplierDashboardLoaded(this.stats);
}

class HomeError extends HomeState {
  final String message;
  final String? code;

  const HomeError(this.message, {this.code});
}
