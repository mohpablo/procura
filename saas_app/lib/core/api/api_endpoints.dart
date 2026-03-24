class EndPoints {
  // Base URL - Update this to your Laravel backend URL
  static const String baseUrl = 'http://10.207.139.197:8000/api/v1';

  // ========== Auth Endpoints ==========
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String me = '/auth/me';

  // ========== Public Product Endpoints ==========
  static const String products = '/products';
  static String productDetails(int id) => '/products/$id';
  static const String featuredProducts = '/products/featured';
  static const String categories = '/categories';

  // ========== Buyer Endpoints ==========
  // Profile
  static const String buyerProfile = '/buyer/profile';
  static const String buyerStatistics = '/buyer/statistics';

  // Cart
  static const String cart = '/buyer/cart';
  static const String addToCart = '/buyer/cart/add';
  static String updateCart(int productId) => '/buyer/cart/$productId';
  static String removeFromCart(int productId) => '/buyer/cart/$productId';
  static const String clearCart = '/buyer/cart/clear';

  // Orders
  static const String orders = '/buyer/orders';
  static const String checkout = '/buyer/orders/checkout';
  static String orderDetails(int orderId) => '/buyer/orders/$orderId';
  static String cancelOrder(int orderId) => '/buyer/orders/$orderId/cancel';
  static String trackOrder(int orderId) => '/buyer/orders/$orderId/track';

  // Ratings
  static const String availableRatings = '/buyer/ratings/available';
  static const String submitRating = '/buyer/ratings';

  // Notifications
  static const String notifications = '/buyer/notifications';
  static String markNotificationAsRead(int id) =>
      '/buyer/notifications/$id/read';
  static const String markAllNotificationsAsRead =
      '/buyer/notifications/mark-all-read';
  static const String unreadNotificationsCount =
      '/buyer/notifications/unread-count';

  // ========== Supplier Endpoints ==========
  // Dashboard
  static const String supplierDashboardOverview =
      '/supplier/dashboard/overview';
  static const String supplierRecentOrders =
      '/supplier/dashboard/recent-orders';
  static const String supplierOrderStats = '/supplier/dashboard/order-stats';
  static const String supplierRevenue = '/supplier/dashboard/revenue';

  // Products
  static const String supplierProducts = '/supplier/products';
  static String supplierProductDetails(int id) => '/supplier/products/$id';
  static String updateSupplierProduct(int id) => '/supplier/products/$id';
  static String deleteSupplierProduct(int id) => '/supplier/products/$id';
  static const String bulkUpdateStock = '/supplier/products/bulk-update-stock';

  // Orders
  static const String supplierOrders = '/supplier/orders';
  static String supplierOrderDetails(int id) => '/supplier/orders/$id';
  static String confirmOrder(int id) => '/supplier/orders/$id/confirm';
  static String updateOrderStatus(int id) => '/supplier/orders/$id/status';
  static String markReadyForDelivery(int id) =>
      '/supplier/orders/$id/ready-for-delivery';
  static String markStartPreparing(int id) =>
      '/supplier/orders/$id/start-preparing';
  static const String pendingOrdersCount = '/supplier/orders/pending/count';

  // Profile
  static const String supplierProfile = '/supplier/profile';

  // Notifications
  static const String supplierNotifications = '/supplier/notifications';
  static String supplierMarkNotificationAsRead(int id) =>
      '/supplier/notifications/$id/read';
  static const String supplierMarkAllNotificationsAsRead =
      '/supplier/notifications/mark-all-read';
  static const String supplierUnreadNotificationsCount =
      '/supplier/notifications/unread-count';
}

class APIKeys {
  // Common
  static const String success = 'success';
  static const String message = 'message';
  static const String data = 'data';
  static const String errors = 'errors';

  // Auth
  static const String name = 'name';
  static const String email = 'email';
  static const String password = 'password';
  static const String passwordConfirmation = 'password_confirmation';
  static const String role = 'role';
  static const String phone = 'phone';
  static const String address = 'address';
  static const String companyName = 'company_name';
  static const String companyType = 'company_type';
  static const String companyAddress = 'company_address';
  static const String token = 'token';
  static const String user = 'user';
  static const String deviceName = 'device_name';

  // Products
  static const String productId = 'product_id';
  static const String categoryId = 'category_id';
  static const String unit = 'unit';
  static const String stock = 'stock';
  static const String minOrderQty = 'min_order_qty';
  static const String quantity = 'quantity';
  static const String price = 'price';
  static const String minPrice = 'min_price';
  static const String maxPrice = 'max_price';
  static const String search = 'search';
  static const String sortBy = 'sort_by';
  static const String page = 'page';
  static const String perPage = 'per_page';

  // Cart
  static const String cartItems = 'cart_items';
  static const String count = 'count';
  static const String total = 'total';
  static const String subtotal = 'subtotal';
  static const String tax = 'tax';

  // Orders
  static const String orderId = 'order_id';
  static const String orderNumber = 'order_number';
  static const String status = 'status';
  static const String totalAmount = 'total_amount';
  static const String paymentMethod = 'payment_method';
  static const String shippingAddress = 'shipping_address';
  static const String items = 'items';

  // Ratings
  static const String rating = 'rating';
  static const String comment = 'comment';

  // Notifications
  static const String title = 'title';
  static const String type = 'type';
  static const String isRead = 'is_read';
  static const String unreadCount = 'unread_count';
  static const String relatedId = 'related_id';

  // Pagination
  static const String currentPage = 'current_page';
  static const String lastPage = 'last_page';
  static const String totalItems = 'total';
}
