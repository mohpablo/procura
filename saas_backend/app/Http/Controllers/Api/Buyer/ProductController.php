<?php

namespace App\Http\Controllers\Api\Buyer;

use App\Http\Controllers\Controller;
use App\Http\Requests\Products\GetProductsRequest;
use App\Models\Product;
use App\Models\Category;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    /**
     * Get all products with filtering and search
     */
    public function index(GetProductsRequest $request): JsonResponse
    {
        try {
            $query = Product::with('supplier', 'category')
                ->where('stock', '>', 0);

            // Search
            if ($request->search) {
                $query->where('name', 'like', '%' . $request->search . '%')
                    ->orWhere('description', 'like', '%' . $request->search . '%');
            }

            // Filter by category
            if ($request->category_id) {
                $query->where('category_id', $request->category_id);
            }

            // Filter by supplier
            if ($request->supplier_id) {
                $query->where('supplier_id', $request->supplier_id);
            }

            // Price range filter
            if ($request->min_price) {
                $query->where('price', '>=', $request->min_price);
            }
            if ($request->max_price) {
                $query->where('price', '<=', $request->max_price);
            }

            // Sorting
            switch ($request->sort_by) {
                case 'price_asc':
                    $query->orderBy('price', 'asc');
                    break;
                case 'price_desc':
                    $query->orderBy('price', 'desc');
                    break;
                case 'newest':
                    $query->orderBy('created_at', 'desc');
                    break;
                case 'popular':
                    $query->orderBy('stock', 'desc');
                    break;
                default:
                    $query->orderBy('created_at', 'desc');
            }

            $perPage = $request->per_page ?? 20;
            $products = $query->paginate($perPage);

            return response()->json([
                'success' => true,
                'data' => $products,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch products: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get single product details
     */
    public function show(Product $product): JsonResponse
    {
        try {
            $product->load('supplier', 'category', 'orderItems');

            return response()->json([
                'success' => true,
                'data' => $product,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch product: ' . $e->getMessage(),
            ], 404);
        }
    }

    /**
     * Get all categories
     */
    public function categories(): JsonResponse
    {
        try {
            $categories = Category::withCount('products')->get();

            return response()->json([
                'success' => true,
                'data' => $categories,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch categories: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get featured products
     */
    public function featured(): JsonResponse
    {
        try {
            $products = Product::with('supplier', 'category')
                ->where('stock', '>', 0)
                ->inRandomOrder()
                ->limit(10)
                ->get();

            return response()->json([
                'success' => true,
                'data' => $products,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch featured products: ' . $e->getMessage(),
            ], 400);
        }
    }
}
