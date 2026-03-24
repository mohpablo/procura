<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class OrderItem extends Model
{
    use SoftDeletes;
    protected $table = 'order_items';

    protected $fillable = [
        'order_id',
        'product_id',
        'quantity',
        'unit_price',
        'total_price',
    ];

    protected $casts = [
        'unit_price' => 'decimal:2',
        'total_price' => 'decimal:2',
    ];

    /**
     * Get the order that this item belongs to.
     */
    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    /**
     * Get the product for this order item.
     */
    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}
