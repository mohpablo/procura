<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Order extends Model
{
    use SoftDeletes;
    protected $fillable = [
        'buyer_id',
        'supplier_id',
        'total_amount',
        'status',
        'payment_status',
        'scheduled_delivery',
    ];

    protected $casts = [
        'total_amount' => 'decimal:2',
        'scheduled_delivery' => 'date',
    ];

    /**
     * Get the buyer (user) who placed the order.
     */
    public function buyer()
    {
        return $this->belongsTo(User::class, 'buyer_id');
    }

    /**
     * Get the supplier (company) who will fulfill the order.
     */
    public function supplier()
    {
        return $this->belongsTo(Company::class, 'supplier_id');
    }

    /**
     * Get all items in this order.
     */
    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }

    /**
     * Get the rating for this order.
     */
    public function rating()
    {
        return $this->hasOne(Rating::class);
    }
}
