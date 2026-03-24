<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Rating extends Model
{
    use SoftDeletes;
    protected $fillable = [
        'order_id',
        'buyer_id',
        'supplier_id',
        'rating',
        'comment',
    ];

    protected $casts = [
        'rating' => 'integer',
    ];

    /**
     * Get the order being rated.
     */
    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    /**
     * Get the buyer who gave the rating.
     */
    public function buyer()
    {
        return $this->belongsTo(User::class, 'buyer_id');
    }

    /**
     * Get the supplier being rated.
     */
    public function supplier()
    {
        return $this->belongsTo(Company::class, 'supplier_id');
    }
}
