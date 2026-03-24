<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Company extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'name',
        'type',
        'phone',
        'email',
        'address',
        'description',
        'is_verified',
    ];

    /**
     * Get all users in this company.
     */
    public function users()
    {
        return $this->hasMany(User::class);
    }

    /**
     * Get all products listed by this supplier.
     */
    public function products()
    {
        return $this->hasMany(Product::class, 'supplier_id');
    }

    /**
     * Get all orders where this company is the supplier.
     */
    public function orders()
    {
        return $this->hasMany(Order::class, 'supplier_id');
    }

    /**
     * Get all ratings for this supplier.
     */
    public function ratings()
    {
        return $this->hasMany(Rating::class, 'supplier_id');
    }

    /**
     * Get all documents for this company.
     */
    public function documents()
    {
        return $this->hasMany(Document::class);
    }
}
