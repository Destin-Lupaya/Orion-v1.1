<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CautionHistory extends Model
{
    use HasFactory;

    protected $fillable = [
        'activity_id',
        'account_id',
        'external_clients_id',
        'amount',
        'currency',
        'motif',
        'type_operation',
    ];
}
