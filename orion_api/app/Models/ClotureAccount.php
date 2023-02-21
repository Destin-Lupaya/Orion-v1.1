<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ClotureAccount extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var string[]
     */
    protected $fillable = [
        'amount_usd',
        'amount_cdf',
        'sender_id',
        'receiver_id',
        'received_usd',
        'received_cdf',
        'status',
        'date_send',
        'date_received',
    ];

    // function billetage(){
    //    return $this->hasMany() 
    // }

    public function billetage()
    {
        return $this->hasMany(Billetage::class);
    }
}
