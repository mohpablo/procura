@extends('layouts.app')

@section('title', 'Supplier Products')
@section('header_title', 'Product Management')

@section('content')
<div class="card-container">
    <div class="card-header">
        <h3 style="margin: 0; font-size: 1.125rem; font-weight: 600;">All Products</h3>
        <div style="display: flex; gap: 0.75rem;">
            <button class="btn btn-primary" style="background: var(--secondary);">
                <i class="fas fa-file-export"></i> Export Template
            </button>
            <button class="btn btn-primary">
                <i class="fas fa-plus"></i> Add Product
            </button>
        </div>
    </div>
    <table class="premium-table">
        <thead>
            <tr>
                <th>Product</th>
                <th>Category</th>
                <th>Price</th>
                <th>Stock</th>
                <th>Min Qty</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            @forelse($products as $product)
                <tr>
                    <td>
                        <div style="font-weight: 600;">{{ $product->name }}</div>
                        <div style="font-size: 0.75rem; color: var(--text-muted);">Unit: {{ $product->unit }}</div>
                    </td>
                    <td>{{ $product->category->name }}</td>
                    <td>${{ number_format($product->price, 2) }}</td>
                    <td>
                        <span style="{{ $product->stock < 10 ? 'color: var(--danger); font-weight: 700;' : '' }}">
                            {{ $product->stock }}
                        </span>
                    </td>
                    <td>{{ $product->min_order_qty }}</td>
                    <td>
                        <div style="display: flex; gap: 0.5rem;">
                            <button title="Edit" style="background: none; border: none; color: var(--primary); cursor: pointer;"><i class="fas fa-edit"></i></button>
                            <button title="Delete" style="background: none; border: none; color: var(--danger); cursor: pointer;"><i class="fas fa-trash"></i></button>
                        </div>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="6" style="text-align: center; padding: 2rem; color: var(--text-muted);">No products found.</td>
                </tr>
            @endforelse
        </tbody>
    </table>
    <div style="padding: 1rem; border-top: 1px solid var(--border);">
        {{ $products->links() }}
    </div>
</div>
@endsection
