<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PointsConfig extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'value',
        'to_usd',
        'to_cdf'
    ];
}
