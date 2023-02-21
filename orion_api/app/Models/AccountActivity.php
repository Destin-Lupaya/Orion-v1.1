<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class AccountActivity extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var string[]
     */
    protected $fillable = [
        'activity_id',
        'account_id',
        'virtual_cdf',
        'virtual_usd',
        'stock',
        'pret_cdf',
        'pret_usd',
        'emprunt_cdf',
        'emprunt_usd',
        'bonus_usd',
        'bonus_cdf',
        'percentage'
    ];

    
}
