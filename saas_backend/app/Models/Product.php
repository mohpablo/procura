<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'supplier_id',
        'category_id',
        'name',
        'unit',
        'price',
        'min_order_qty',
        'stock',
        'description',
        'images',
    ];

    protected $casts = [
        'images' => 'array',
        'price' => 'decimal:2',
    ];

    /**
     * Get the supplier (company) that owns this product.
     */
    public function supplier()
    {
        return $this->belongsTo(Company::class, 'supplier_id');
    }

    /**
     * Get the category that owns this product.
     */
    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    /**
     * Get all order items for this product.
     */
    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }
}
