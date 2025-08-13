<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Website extends Model
{
    use HasFactory;

    protected $fillable = ['url', 'is_blacklisted', 'reason'];
    public const BLACKLISTED = 1;
    public const WHITELISTED = 0;


    // Lọc theo blacklist
    public function scopeBlacklist($query)
    {
        return $query->where('is_blacklisted', 1);
    }

    // Lọc theo whitelist
    public function scopeWhitelist($query)
    {
        return $query->where('is_blacklisted', 0);
    }
}
