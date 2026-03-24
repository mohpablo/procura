<?php

namespace App\Http\Controllers\Api\Buyer;

use App\Http\Controllers\Controller;
use App\Http\Requests\Cart\AddToCartRequest;
use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CartController extends Controller
{
    /**
     * Get user's cart from session/cache
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $userId = $request->user()->id;
            $cart = cache()->get('cart_' . $userId, []);

            // Calculate cart totals
            $total = 0;
            $items = [];

            foreach ($cart as $productId => $cartItem) {
                $product = Product::find($productId);
                if ($product) {
                    $itemTotal = $product->price * $cartItem['quantity'];
                    $total += $itemTotal;
                    $items[] = [
                        'product' => $product,
                        'quantity' => $cartItem['quantity'],
                        'total' => $itemTotal,
                    ];
                }
            }

            return response()->json([
                'success' => true,
                'data' => [
                    'items' => $items,
                    'count' => count($items),
                    'total' => $total,
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch cart: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Add product to cart
     */
    public function add(AddToCartRequest $request): JsonResponse
    {
        try {
            $userId = $request->user()->id;
            $productId = $request->product_id;
            $quantity = $request->quantity;

            $product = Product::findOrFail($productId);

            if ($product->stock < $quantity) {
                return response()->json([
                    'success' => false,
                    'message' => 'Insufficient stock available',
                ], 422);
            }

            $cart = cache()->get('cart_' . $userId, []);

            if (isset($cart[$productId])) {
                $cart[$productId]['quantity'] += $quantity;
            } else {
                $cart[$productId] = [
                    'quantity' => $quantity,
                    'added_at' => now(),
                ];
            }

            cache()->put('cart_' . $userId, $cart, 7 * 24 * 60); // 7 days

            return response()->json([
                'success' => true,
                'message' => 'Product added to cart',
                'data' => $cart,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to add to cart: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Update cart item quantity
     */
    public function update(Request $request, Product $product): JsonResponse
    {
        try {
            $request->validate([
                'quantity' => ['required', 'integer', 'min:1'],
            ]);

            $userId = $request->user()->id;
            $quantity = $request->quantity;

            if ($product->stock < $quantity) {
                return response()->json([
                    'success' => false,
                    'message' => 'Insufficient stock available',
                ], 422);
            }

            $cart = cache()->get('cart_' . $userId, []);

            if (isset($cart[$product->id])) {
                $cart[$product->id]['quantity'] = $quantity;
            }

            cache()->put('cart_' . $userId, $cart, 7 * 24 * 60);

            return response()->json([
                'success' => true,
                'message' => 'Cart updated',
                'data' => $cart,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update cart: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Remove product from cart
     */
    public function remove(Request $request, Product $product): JsonResponse
    {
        try {
            $userId = $request->user()->id;
            $cart = cache()->get('cart_' . $userId, []);

            unset($cart[$product->id]);

            cache()->put('cart_' . $userId, $cart, 7 * 24 * 60);

            return response()->json([
                'success' => true,
                'message' => 'Product removed from cart',
                'data' => $cart,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to remove from cart: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Clear cart
     */
    public function clear(Request $request): JsonResponse
    {
        try {
            $userId = $request->user()->id;
            cache()->forget('cart_' . $userId);

            return response()->json([
                'success' => true,
                'message' => 'Cart cleared',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to clear cart: ' . $e->getMessage(),
            ], 400);
        }
    }
}
