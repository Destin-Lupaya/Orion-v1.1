<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CautionModel extends Model
{
    use HasFactory;

    protected $table = 'cautions';


    protected $fillable = [
        'external_clients_id',
        'amount'
    ];
}
