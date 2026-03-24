<?php

namespace App\Http\Controllers\Api\Supplier;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    /**
     * Get supplier dashboard overview
     */
    public function overview(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            $company = $user->company;

            $totalOrders = $company->orders()->count();
            $totalRevenue = $company->orders()->where('status', 'delivered')->sum('total_amount');
            $averageRating = $company->ratings()->avg('rating') ?? 0;

            $stats = [
                'total_products' => $company->products()->count(),
                'total_stock' => $company->products()->sum('stock'),
                'low_stock_products' => $company->products()->where('stock', '<', 10)->count(),
                'pending_orders' => $company->orders()->where('status', 'pending')->count(),
                'confirmed_orders' => $company->orders()->where('status', 'confirmed')->count(),
                'total_orders' => $totalOrders,
                'completed_orders' => $company->orders()->where('status', 'delivered')->count(),
                'total_revenue' => $totalRevenue,
                'average_order_value' => $totalOrders > 0 ? $totalRevenue / $totalOrders : 0,
                'average_rating' => $averageRating,
                'rating' => $averageRating, // Alias for model
                'total_ratings' => $company->ratings()->count(),
                'company_verified' => $company->is_verified,
            ];

            return response()->json([
                'success' => true,
                'data' => $stats,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch dashboard: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get recent orders
     */
    public function recentOrders(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            $orders = $user->company->orders()
                ->with('buyer', 'orderItems.product')
                ->orderBy('created_at', 'desc')
                ->limit(10)
                ->get();

            return response()->json([
                'success' => true,
                'data' => $orders,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch recent orders: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get order statistics
     */
    public function orderStats(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            $company = $user->company;

            $stats = [
                'by_status' => [
                    'pending' => $company->orders()->where('status', 'pending')->count(),
                    'confirmed' => $company->orders()->where('status', 'confirmed')->count(),
                    'preparing' => $company->orders()->where('status', 'preparing')->count(),
                    'ready_for_delivery' => $company->orders()->where('status', 'ready_for_delivery')->count(),
                    'scheduled' => $company->orders()->where('status', 'scheduled')->count(),
                    'delivered' => $company->orders()->where('status', 'delivered')->count(),
                    'cancelled' => $company->orders()->where('status', 'cancelled')->count(),
                ],
                'by_payment' => [
                    'pending' => $company->orders()->where('payment_status', 'pending')->count(),
                    'paid' => $company->orders()->where('payment_status', 'paid')->count(),
                    'failed' => $company->orders()->where('payment_status', 'failed')->count(),
                ],
            ];

            return response()->json([
                'success' => true,
                'data' => $stats,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch order stats: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get revenue analytics
     */
    public function revenue(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            $company = $user->company;
            $period = $request->query('period', 'month'); // month, year, all

            $query = $company->orders()->where('status', 'delivered');

            if ($period === 'month') {
                $query->whereMonth('created_at', now()->month)
                    ->whereYear('created_at', now()->year);
            } elseif ($period === 'year') {
                $query->whereYear('created_at', now()->year);
            }

            $revenue = $query->sum('total_amount');
            $orderCount = $query->count();
            $averageOrderValue = $orderCount > 0 ? $revenue / $orderCount : 0;

            return response()->json([
                'success' => true,
                'data' => [
                    'period' => $period,
                    'total_revenue' => $revenue,
                    'order_count' => $orderCount,
                    'average_order_value' => $averageOrderValue,
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch revenue data: ' . $e->getMessage(),
            ], 400);
        }
    }
}
