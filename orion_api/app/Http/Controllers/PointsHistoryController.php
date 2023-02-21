<?php

namespace App\Http\Controllers;

use App\Models\PointsHistory;
use Illuminate\Http\Request;

class PointsHistoryController extends Controller
{
    static public function saveHistory($activity_id, $amount, $points, $type_operation,  $client_number, $action)
    {
        $history = [
            "activity_id" => $activity_id,
            "client_number" => $client_number,
            "montant_transaction" => $amount,
            "points" => $points,
            "type_operation" => $type_operation,
            "action" => $action,

        ];
        PointsHistory::create($history);
    }
}
