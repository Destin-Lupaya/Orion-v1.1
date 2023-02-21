<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Account extends Model
{
    use HasFactory;


    /**
     * The attributes that are mass assignable.
     *
     * @var string[]
     */
    protected $fillable = [
        'created_users_id',
        'sold_cash_cdf',
        'sold_cash_usd',
        'statusActive',
        'branch_id',
        'sold_pret_cdf',
        'sold_pret_usd',
        'sold_emprunt_cdf',
        'sold_emprunt_usd',
        'users_id'
    ];

    function getActivities(){

        return $this->hasMany('App\Models\AccountActivity');
    }
}
