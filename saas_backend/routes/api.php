<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\Buyer\ProductController as BuyerProductController;
use App\Http\Controllers\Api\Buyer\CartController;
use App\Http\Controllers\Api\Buyer\OrderController as BuyerOrderController;
use App\Http\Controllers\Api\Buyer\RatingController;
use App\Http\Controllers\Api\Buyer\NotificationController;
use App\Http\Controllers\Api\Buyer\ProfileController as BuyerProfileController;
use App\Http\Controllers\Api\Supplier\DashboardController;
use App\Http\Controllers\Api\Supplier\ProductController as SupplierProductController;
use App\Http\Controllers\Api\Supplier\OrderController as SupplierOrderController;
use App\Http\Controllers\Api\Admin\DashboardController as AdminDashboardController;
use App\Http\Controllers\Api\Admin\SupplierController as AdminSupplierController;
use App\Http\Controllers\Api\Admin\OrderController as AdminOrderController;
use App\Http\Controllers\Api\Admin\ProductController as AdminProductController;
use App\Http\Controllers\Api\Admin\RatingController as AdminRatingController;
use App\Http\Controllers\Api\Supplier\CompanyController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application.
|
*/

// ========================================
// Public Auth Routes (No Authentication)
// ========================================
Route::prefix('v1')->group(function () {
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);

    // Public product browsing
    Route::get('/products', [BuyerProductController::class, 'index']);
    Route::get('/products/{product}', [BuyerProductController::class, 'show']);
    Route::get('/products/featured', [BuyerProductController::class, 'featured']);
    Route::get('/categories', [BuyerProductController::class, 'categories']);

    // ====================================
    // Protected Routes (Authenticated Users)
    // ====================================
    Route::middleware('auth:sanctum')->group(function () {

        // ========== Auth Routes ==========
        Route::post('/auth/logout', [AuthController::class, 'logout']);
        Route::post('/auth/refresh-token', [AuthController::class, 'refreshToken']);
        Route::get('/auth/me', [AuthController::class, 'me']);

        // ========== Buyer Routes ==========
        Route::middleware('buyer')->prefix('buyer')->group(function () {

            // Profile Management
            Route::get('/profile', [BuyerProfileController::class, 'show']);
            Route::put('/profile', [BuyerProfileController::class, 'update']);
            Route::get('/statistics', [BuyerProfileController::class, 'statistics']);

            // Cart Management
            Route::get('/cart', [CartController::class, 'index']);
            Route::post('/cart/add', [CartController::class, 'add']);
            Route::put('/cart/{product}', [CartController::class, 'update']);
            Route::delete('/cart/{product}', [CartController::class, 'remove']);
            Route::post('/cart/clear', [CartController::class, 'clear']);

            // Orders
            Route::get('/orders', [BuyerOrderController::class, 'index']);
            Route::post('/orders/checkout', [BuyerOrderController::class, 'checkout']);
            Route::get('/orders/{order}', [BuyerOrderController::class, 'show']);
            Route::post('/orders/{order}/cancel', [BuyerOrderController::class, 'cancel']);
            Route::get('/orders/{order}/track', [BuyerOrderController::class, 'track']);
            Route::get('/orders/{order}/invoice', [BuyerOrderController::class, 'downloadInvoice']);

            // Ratings
            Route::get('/ratings/available', [RatingController::class, 'available']);
            Route::post('/ratings', [RatingController::class, 'store']);

            // Notifications
            Route::get('/notifications', [NotificationController::class, 'index']);
            Route::put('/notifications/{notification}/read', [NotificationController::class, 'markAsRead']);
            Route::post('/notifications/mark-all-read', [NotificationController::class, 'markAllAsRead']);
            Route::get('/notifications/unread-count', [NotificationController::class, 'unreadCount']);
        });

        // ========== Supplier Routes ==========
        Route::middleware('supplier')->prefix('supplier')->group(function () {

            // Dashboard
            Route::get('/dashboard/overview', [DashboardController::class, 'overview']);
            Route::get('/dashboard/recent-orders', [DashboardController::class, 'recentOrders']);
            Route::get('/dashboard/order-stats', [DashboardController::class, 'orderStats']);
            Route::get('/dashboard/revenue', [DashboardController::class, 'revenue']);

            // Products
            Route::get('/products', [SupplierProductController::class, 'index']);
            Route::post('/products', [SupplierProductController::class, 'store']);
            Route::get('/products/{product}', [SupplierProductController::class, 'show']);
            Route::put('/products/{product}', [SupplierProductController::class, 'update']);
            Route::delete('/products/{product}', [SupplierProductController::class, 'destroy']);
            Route::post('/products/bulk-update-stock', [SupplierProductController::class, 'bulkUpdateStock']);

            // Orders
            Route::get('/orders', [SupplierOrderController::class, 'index']);
            Route::get('/orders/{order}', [SupplierOrderController::class, 'show']);
            Route::post('/orders/{order}/confirm', [SupplierOrderController::class, 'confirm']);
            Route::put('/orders/{order}/status', [SupplierOrderController::class, 'updateStatus']);
            Route::post('/orders/{order}/ready-for-delivery', [SupplierOrderController::class, 'readyForDelivery']);
            Route::post('/orders/{order}/start-preparing', [SupplierOrderController::class, 'startPreparing']);
            Route::get('/orders/pending/count', [SupplierOrderController::class, 'pendingCount']);

            // Company Profile
            Route::get('/company', [CompanyController::class, 'show']);
            Route::put('/company', [CompanyController::class, 'update']);
            Route::get('/company/ratings', [CompanyController::class, 'ratings']);
            Route::post('/company/documents', [CompanyController::class, 'uploadDocument']);
            Route::get('/company/documents', [CompanyController::class, 'documents']);

            // User Profile (Shared logic)
            Route::get('/profile', [BuyerProfileController::class, 'show']);
            Route::put('/profile', [BuyerProfileController::class, 'update']);

            // Notifications (Shared logic)
            Route::get('/notifications', [NotificationController::class, 'index']);
            Route::put('/notifications/{notification}/read', [NotificationController::class, 'markAsRead']);
            Route::post('/notifications/mark-all-read', [NotificationController::class, 'markAllAsRead']);
            Route::get('/notifications/unread-count', [NotificationController::class, 'unreadCount']);
        });

    });
});
