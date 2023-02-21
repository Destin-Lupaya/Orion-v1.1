<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class cloture_incidents extends Model
{
    use HasFactory;


    protected $fillable = [
        'cloture_account_id',
        'montant',
        'currency',
        'type_incident'
    ];
}
