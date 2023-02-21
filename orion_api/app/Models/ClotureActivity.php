<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ClotureActivity extends Model
{
    use HasFactory;
    protected $fillable = [
        'cloture_id',
        'activity_id',
        'amount_usd',
        'amount_cdf',
        'stock',
        'received_usd',
        'received_cdf',
        'received_stock',
    ];
}
