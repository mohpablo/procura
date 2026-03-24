<?php

namespace App\Http\Controllers\Api\Buyer;

use App\Http\Controllers\Controller;
use App\Http\Requests\Orders\CheckoutRequest;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    /**
     * Get all orders for authenticated buyer
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $orders = Order::where('buyer_id', $request->user()->id)
                ->with('supplier', 'orderItems.product')
                ->orderBy('created_at', 'desc')
                ->paginate(15);

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
     * Create new order from cart (checkout)
     */
    public function checkout(CheckoutRequest $request): JsonResponse
    {
        try {
            $buyer = $request->user();
            $cartItems = $request->cart_items;

            // Group items by supplier
            $itemsBySupplier = [];
            foreach ($cartItems as $item) {
                $product = Product::with('supplier')->findOrFail($item['product_id']);
                $supplierId = $product->supplier_id;

                if (!isset($itemsBySupplier[$supplierId])) {
                    $itemsBySupplier[$supplierId] = [];
                }

                $itemsBySupplier[$supplierId][] = [
                    'product' => $product,
                    'quantity' => $item['quantity'],
                ];
            }

            $orders = [];

            // Create separate order for each supplier
            foreach ($itemsBySupplier as $supplierId => $items) {
                $totalAmount = 0;

                $order = Order::create([
                    'buyer_id' => $buyer->id,
                    'supplier_id' => $supplierId,
                    'total_amount' => 0, // Will be updated
                    'status' => 'pending',
                    'payment_status' => 'pending',
                ]);

                foreach ($items as $item) {
                    $unitPrice = $item['product']->price;
                    $totalPrice = $unitPrice * $item['quantity'];
                    $totalAmount += $totalPrice;

                    OrderItem::create([
                        'order_id' => $order->id,
                        'product_id' => $item['product']->id,
                        'quantity' => $item['quantity'],
                        'unit_price' => $unitPrice,
                        'total_price' => $totalPrice,
                    ]);

                    // Update product stock
                    $item['product']->decrement('stock', $item['quantity']);
                }

                // Update order total
                $order->update(['total_amount' => $totalAmount]);
                $orders[] = $order->load('orderItems.product', 'supplier');
            }

            // Clear cart
            cache()->forget('cart_' . $buyer->id);

            return response()->json([
                'success' => true,
                'message' => 'Orders placed successfully',
                'data' => $orders,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Checkout failed: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get single order details
     */
    public function show(Request $request, Order $order): JsonResponse
    {
        try {
            // Check if buyer owns this order
            if ($order->buyer_id !== $request->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            $order->load('supplier', 'orderItems.product', 'rating');

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
     * Cancel order (only pending orders)
     */
    public function cancel(Request $request, Order $order): JsonResponse
    {
        try {
            if ($order->buyer_id !== $request->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            if ($order->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Can only cancel pending orders',
                ], 422);
            }

            // Restore product stock
            foreach ($order->orderItems as $item) {
                $item->product->increment('stock', $item->quantity);
            }

            $order->update(['status' => 'cancelled']);

            return response()->json([
                'success' => true,
                'message' => 'Order cancelled successfully',
                'data' => $order,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to cancel order: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Track order status
     */
    public function track(Request $request, Order $order): JsonResponse
    {
        try {
            if ($order->buyer_id !== $request->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            return response()->json([
                'success' => true,
                'data' => [
                    'order_id' => $order->id,
                    'status' => $order->status,
                    'payment_status' => $order->payment_status,
                    'scheduled_delivery' => $order->scheduled_delivery,
                    'created_at' => $order->created_at,
                    'updated_at' => $order->updated_at,
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to track order: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Download order invoice as PDF
     */
    public function downloadInvoice(Request $request, Order $order)
    {
        try {
            if ($order->buyer_id !== $request->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            if ($order->status !== 'delivered') {
                return response()->json([
                    'success' => false,
                    'message' => 'Invoice only available for delivered orders',
                ], 400);
            }

            $order->load('supplier', 'orderItems.product', 'buyer.company');

            $pdf = \Barryvdh\DomPDF\Facade\Pdf::loadView('invoices.order', compact('order'));
            
            return $pdf->download('invoice-' . $order->id . '.pdf');

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to generate invoice: ' . $e->getMessage(),
            ], 400);
        }
    }
}
