<?php

namespace App\Http\Controllers\Api\Supplier;

use App\Http\Controllers\Controller;
use App\Http\Requests\Orders\ConfirmOrderRequest;
use App\Models\Order;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    /**
     * Get all orders for supplier
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            $company = $user->company;
            $status = $request->query('status');

            $query = $company->orders()->with('buyer', 'orderItems.product');

            if ($status) {
                $query->where('status', $status);
            }

            $orders = $query->orderBy('created_at', 'desc')->paginate(20);

            return response()->json([
                'success' => true,
                'data' => $orders,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch orders: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get order details
     */
    public function show(Request $request, Order $order): JsonResponse
    {
        try {
            if ($order->supplier_id !== $request->user()->company_id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            $order->load('buyer', 'orderItems.product');

            return response()->json([
                'success' => true,
                'data' => $order,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch order: ' . $e->getMessage(),
            ], 404);
        }
    }

    /**
     * Confirm or reject order
     */
    public function confirm(ConfirmOrderRequest $request, Order $order): JsonResponse
    {
        try {
            if ($order->supplier_id !== $request->user()->company_id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            if ($order->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Only pending orders can be confirmed',
                ], 422);
            }

            if ($request->status === 'confirmed') {
                $order->update(['status' => 'confirmed']);
                $message = 'Order confirmed';
                
                \App\Models\Notification::create([
                    'user_id' => $order->buyer_id,
                    'title' => 'Order Confirmed',
                    'message' => 'Your order #' . $order->id . ' has been confirmed by the supplier.',
                    'type' => 'order_status',
                ]);
            } else {
                $order->update(['status' => 'cancelled']);
                
                \App\Models\Notification::create([
                    'user_id' => $order->buyer_id,
                    'title' => 'Order Rejected',
                    'message' => 'Your order #' . $order->id . ' has been rejected by the supplier.',
                    'type' => 'order_status',
                ]);

                // Restore stock
                foreach ($order->orderItems as $item) {
                    $item->product->increment('stock', $item->quantity);
                }

                $message = 'Order rejected';
            }

            return response()->json([
                'success' => true,
                'message' => $message,
                'data' => $order,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to confirm order: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Update order status
     */
    public function updateStatus(Request $request, Order $order): JsonResponse
    {
        try {
            $request->validate([
                'status' => [
                    'required',
                    'in:confirmed,preparing,ready_for_delivery,scheduled,delivered,cancelled'
                ],
            ]);

            if ($order->supplier_id !== $request->user()->company_id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            $order->update(['status' => $request->status]);

            \App\Models\Notification::create([
                'user_id' => $order->buyer_id,
                'title' => 'Order Status Updated',
                'message' => 'Your order #' . $order->id . ' status has been updated to ' . str_replace('_', ' ', $request->status) . '.',
                'type' => 'order_status',
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Order status updated',
                'data' => $order,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update status: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Start preparing the order
     */
    public function startPreparing(Request $request, Order $order): JsonResponse
    {
        try {
            if ($order->supplier_id !== $request->user()->company_id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            if ($order->status !== 'confirmed') {
                return response()->json([
                    'success' => false,
                    'message' => 'Order must be confirmed first',
                ], 422);
            }

            $order->update(['status' => 'preparing']);

            \App\Models\Notification::create([
                'user_id' => $order->buyer_id,
                'title' => 'Order Preparing',
                'message' => 'The supplier has started preparing your order #' . $order->id . '.',
                'type' => 'order_status',
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Order is now being prepared',
                'data' => $order,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update status: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Mark order ready for delivery
     */
    public function readyForDelivery(Request $request, Order $order): JsonResponse
    {
        try {
            if ($order->supplier_id !== $request->user()->company_id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            if (!in_array($order->status, ['confirmed', 'preparing'])) {
                return response()->json([
                    'success' => false,
                    'message' => 'Order must be confirmed or preparing status',
                ], 422);
            }

            $order->update(['status' => 'ready_for_delivery']);

            \App\Models\Notification::create([
                'user_id' => $order->buyer_id,
                'title' => 'Ready for Delivery',
                'message' => 'Your order #' . $order->id . ' is now ready for delivery.',
                'type' => 'order_status',
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Order marked ready for delivery',
                'data' => $order,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to mark ready: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get pending orders count
     */
    public function pendingCount(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            $count = $user->company->orders()
                ->where('status', 'pending')
                ->count();

            return response()->json([
                'success' => true,
                'data' => ['pending_count' => $count],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch count: ' . $e->getMessage(),
            ], 400);
        }
    }
}
