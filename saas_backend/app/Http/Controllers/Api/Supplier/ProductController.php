<?php

namespace App\Http\Controllers\Api\Supplier;

use App\Http\Controllers\Controller;
use App\Http\Requests\Products\StoreProductRequest;
use App\Http\Requests\Products\UpdateProductRequest;
use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    /**
     * Get supplier's products
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            $company = $user->company;
            $search = $request->query('search');
            $category = $request->query('category_id');

            $query = $company->products()->with('category');

            if ($search) {
                $query->where('name', 'like', '%' . $search . '%');
            }

            if ($category) {
                $query->where('category_id', $category);
            }

            $products = $query->paginate(20);

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
     * Create new product
     */
    public function store(StoreProductRequest $request): JsonResponse
    {
        try {
            $user = $request->user();
            $company = $user->company;

            $images = [];
            if ($request->hasFile('images')) {
                foreach ($request->file('images') as $image) {
                    $path = $image->store('products', 'public');
                    $images[] = $path;
                }
            }

            $product = $company->products()->create([
                'category_id' => $request->category_id,
                'name' => $request->name,
                'unit' => $request->unit,
                'price' => $request->price,
                'min_order_qty' => $request->min_order_qty ?? 1,
                'stock' => $request->stock ?? 0,
                'description' => $request->description,
                'images' => !empty($images) ? $images : null,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Product created successfully',
                'data' => $product,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create product: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get single product
     */
    public function show(Request $request, Product $product): JsonResponse
    {
        try {
            if ($product->supplier_id !== $request->user()->company_id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            $product->load('category', 'orderItems');

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
     * Update product
     */
    public function update(UpdateProductRequest $request, Product $product): JsonResponse
    {
        try {
            if ($product->supplier_id !== $request->user()->company_id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            $images = $product->images ?? [];
            if ($request->hasFile('images')) {
                foreach ($request->file('images') as $image) {
                    $path = $image->store('products', 'public');
                    $images[] = $path;
                }
            }

            $product->update([
                'category_id' => $request->category_id ?? $product->category_id,
                'name' => $request->name ?? $product->name,
                'unit' => $request->unit ?? $product->unit,
                'price' => $request->price ?? $product->price,
                'min_order_qty' => $request->min_order_qty ?? $product->min_order_qty,
                'stock' => $request->stock !== null ? $request->stock : $product->stock,
                'description' => $request->description ?? $product->description,
                'images' => !empty($images) ? $images : null,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Product updated successfully',
                'data' => $product->fresh(),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update product: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Delete product
     */
    public function destroy(Request $request, Product $product): JsonResponse
    {
        try {
            if ($product->supplier_id !== $request->user()->company_id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            $product->delete();

            return response()->json([
                'success' => true,
                'message' => 'Product deleted successfully',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to delete product: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Bulk update stock
     */
    public function bulkUpdateStock(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'products' => ['required', 'array'],
                'products.*.id' => ['required', 'integer', 'exists:products,id'],
                'products.*.stock' => ['required', 'integer', 'min:0'],
            ]);

            $user = $request->user();
            $company = $user->company;

            foreach ($request->products as $item) {
                $product = Product::find($item['id']);
                if ($product && $product->supplier_id === $company->id) {
                    $product->update(['stock' => $item['stock']]);
                }
            }

            return response()->json([
                'success' => true,
                'message' => 'Stock updated successfully',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update stock: ' . $e->getMessage(),
            ], 400);
        }
    }
}
