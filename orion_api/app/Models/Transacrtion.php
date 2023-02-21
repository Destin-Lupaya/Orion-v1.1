<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transacrtion extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var string[]
     */
    protected $fillable = [
        'sender',
        'receiver',
        'refkey',
        'amount',
        'quantity',
        'dateTrans',
        'type_operation',
        'type_devise',
        'type_transaction',
        'type_payment',
        'client_number',
        'account_id',
        'account_activity_id',
        'demands_id',
        'users_id'
    ];
}
