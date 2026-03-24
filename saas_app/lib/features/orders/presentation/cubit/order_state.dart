part of 'order_cubit.dart';

sealed class OrderState {
  const OrderState();
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrdersLoaded extends OrderState {
  final List<Order> orders;
  final int currentPage;
  final bool hasMore;

  const OrdersLoaded({
    required this.orders,
    required this.currentPage,
    required this.hasMore,
  });
}

class OrderDetailLoading extends OrderState {
  const OrderDetailLoading();
}

class OrderDetailLoaded extends OrderState {
  final Order order;

  const OrderDetailLoaded(this.order);
}

class OrderCreated extends OrderState {
  final Order order;

  const OrderCreated(this.order);
}

class OrderCancelled extends OrderState {
  final int orderId;

  const OrderCancelled(this.orderId);
}

class OrderError extends OrderState {
  final String message;
  final String? code;

  const OrderError(this.message, {this.code});
}
