<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Demand extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var string[]
     */
    protected $fillable = [
        'sender_id',
        'receiver_id',
        'amount',
        'amount_send',
        'type_devise',
        'type_transaction',
        'status',
        'activity_id',
        'alerte'
    ];

}