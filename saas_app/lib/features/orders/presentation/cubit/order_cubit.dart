import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/features/orders/domain/entities/order.dart';
import 'package:saas_app/features/orders/domain/usecases/order_usecases.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final GetOrdersUseCase getOrdersUseCase;
  final GetOrderByIdUseCase getOrderByIdUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final CancelOrderUseCase cancelOrderUseCase;
  final ConfirmOrderUseCase confirmOrderUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;

  OrderCubit({
    required this.getOrdersUseCase,
    required this.getOrderByIdUseCase,
    required this.createOrderUseCase,
    required this.cancelOrderUseCase,
    required this.confirmOrderUseCase,
    required this.updateOrderStatusUseCase,
  }) : super(const OrderInitial());

  Future<void> getOrders({int page = 1}) async {
    emit(const OrderInitial()); // Reset state for fresh load
    emit(const OrderLoading());

    final result = await getOrdersUseCase(GetOrdersParams(page: page));

    result.when(
      onSuccess: (orders) {
        emit(
          OrdersLoaded(
            orders: orders,
            currentPage: page,
            hasMore: orders.isNotEmpty,
          ),
        );
      },
      onFailure: (message, code) {
        emit(OrderError(message, code: code));
      },
    );
  }

  Future<void> loadMoreOrders({required int nextPage}) async {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;
      final result = await getOrdersUseCase(GetOrdersParams(page: nextPage));

      result.when(
        onSuccess: (newOrders) {
          final allOrders = [...currentState.orders, ...newOrders];
          emit(
            OrdersLoaded(
              orders: allOrders,
              currentPage: nextPage,
              hasMore: newOrders.isNotEmpty,
            ),
          );
        },
        onFailure: (message, code) {
          emit(OrderError(message, code: code));
        },
      );
    }
  }

  Future<void> getOrderById(int orderId) async {
    emit(const OrderDetailLoading());

    final result = await getOrderByIdUseCase(orderId);

    result.when(
      onSuccess: (order) {
        emit(OrderDetailLoaded(order));
      },
      onFailure: (message, code) {
        emit(OrderError(message, code: code));
      },
    );
  }

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    emit(const OrderLoading());

    final result = await createOrderUseCase(orderData);

    result.when(
      onSuccess: (order) {
        emit(OrderCreated(order));
      },
      onFailure: (message, code) {
        emit(OrderError(message, code: code));
      },
    );
  }

  Future<void> cancelOrder(int orderId) async {
    emit(const OrderLoading());

    final result = await cancelOrderUseCase(orderId);

    result.when(
      onSuccess: (_) {
        emit(OrderCancelled(orderId));
        getOrders(); // Refresh the list
      },
      onFailure: (message, code) {
        emit(OrderError(message, code: code));
      },
    );
  }

  Future<void> confirmOrder(int orderId, String status) async {
    emit(const OrderLoading());

    final result = await confirmOrderUseCase(
      ConfirmOrderParams(orderId: orderId, status: status),
    );

    result.when(
      onSuccess: (_) {
        // Refresh both list and current details
        getOrders(); 
        getOrderById(orderId);
      },
      onFailure: (message, code) {
        emit(OrderError(message, code: code));
      },
    );
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    emit(const OrderLoading());

    final result = await updateOrderStatusUseCase(
      ConfirmOrderParams(orderId: orderId, status: status),
    );

    result.when(
      onSuccess: (_) {
        // Refresh both list and current details
        getOrders();
        getOrderById(orderId);
      },
      onFailure: (message, code) {
        emit(OrderError(message, code: code));
      },
    );
  }

  void refresh() {
    getOrders();
  }
}
