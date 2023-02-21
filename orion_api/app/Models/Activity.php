<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Activity extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var string[]
     */
    protected $fillable = [
        'name',
        'description',
        'avatar',
        'statusActive',
        'cashIn',
        'cashOut',
        'hasStock',
        'hasNegativeSold',
        'web_visibility',
        'points',
        'users_id'
    ];

    function getActivityInput(){
        return $this->hasMany('App\Models\ActiviteInput');
    }

    function getAccount(){

        return $this->hasMany('App\Models\Account');
    }

}
