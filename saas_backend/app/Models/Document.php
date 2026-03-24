<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Document extends Model
{
    use SoftDeletes;
    protected $fillable = [
        'company_id',
        'type',
        'file_path',
        'status',
        'reviewed_at',
        'uploaded_at',
    ];

    protected $casts = [
        'reviewed_at' => 'datetime',
        'uploaded_at' => 'datetime',
    ];

    /**
     * Get the company that owns this document.
     */
    public function company()
    {
        return $this->belongsTo(Company::class);
    }
}
