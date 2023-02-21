<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PointsHistory extends Model
{
    use HasFactory;


    protected $fillable = [
        'activity_id',
        'client_number',
        'montant_transaction',
        'points',
        'type_operation',
        'action',
    ];
}
