<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Notification extends Model
{
    use SoftDeletes;
    protected $fillable = [
        'user_id',
        'title',
        'message',
        'type',
        'read_at',
    ];

    protected $casts = [
        'read_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * Get the user that owns this notification.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Check if notification is read.
     */
    public function isRead()
    {
        return $this->read_at !== null;
    }

    /**
     * Mark notification as read.
     */
    public function markAsRead()
    {
        $this->read_at = now();
        return $this->save();
    }
}
