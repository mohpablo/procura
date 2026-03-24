<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Web\AuthController;
use App\Http\Controllers\Web\SupplierController;
use App\Http\Controllers\Web\AdminController;

Route::get('/', function () {
    return redirect()->route('login');
});

Route::get('/login', [AuthController::class, 'showLogin'])->name('login');
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

// Supplier Routes
Route::middleware(['auth', 'role:supplier'])->prefix('supplier')->name('supplier.')->group(function () {
    Route::get('/dashboard', [SupplierController::class, 'dashboard'])->name('dashboard');
    Route::get('/products', [SupplierController::class, 'products'])->name('products');
    Route::get('/orders', [SupplierController::class, 'orders'])->name('orders');
    Route::get('/analytics', [SupplierController::class, 'analytics'])->name('analytics');
    Route::post('/orders/{order}/status', [SupplierController::class, 'updateStatus'])->name('orders.update-status');
});

// Admin Routes
Route::middleware(['auth', 'role:admin'])->prefix('admin')->name('admin.')->group(function () {
    Route::get('/dashboard', [AdminController::class, 'dashboard'])->name('dashboard');
    Route::get('/suppliers', [AdminController::class, 'suppliers'])->name('suppliers');
    Route::post('/suppliers/{company}/verify', [AdminController::class, 'verify'])->name('suppliers.verify');
    Route::post('/suppliers/{company}/suspend', [AdminController::class, 'suspend'])->name('suppliers.suspend');
    Route::get('/orders', [AdminController::class, 'orders'])->name('orders');
    Route::post('/orders/{order}/status', [AdminController::class, 'updateStatus'])->name('orders.update-status');
    Route::get('/analytics', [AdminController::class, 'analytics'])->name('analytics');
});
