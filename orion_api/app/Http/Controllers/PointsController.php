<?php

namespace App\Http\Controllers;

use App\Http\Requests\StorepointsRequest;
use App\Http\Requests\UpdatepointsRequest;
use App\Models\points;
use App\Models\Activity;
use App\Models\PointsConfig;
use Illuminate\Http\Request;

class PointsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
    }

    // /**
    //  * Show the form for creating a new resource.
    //  *
    //  * @return \Illuminate\Http\Response
    //  */
    // public function create()
    // {
    //     //

    // }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \App\Http\Requests\StorepointsRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
        $client_number = $request->client_number;
        $amount = $request->amount;
        $activity_id = $request->activity_id;
        $response = PointsController::calculatePoints($client_number, $amount, $activity_id, null, null, $request->action);
        return $response;
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\points  $points
     * @return \Illuminate\Http\Response
     */
    public function show(points $points)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\points  $points
     * @return \Illuminate\Http\Response
     */
    public function edit(points $points)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdatepointsRequest  $request
     * @param  \App\Models\points  $points
     * @return \Illuminate\Http\Response
     */
    public function update(UpdatepointsRequest $request, points $points)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\points  $points
     * @return \Illuminate\Http\Response
     */
    public function destroy(points $points)
    {
        //
    }

    static public function calculatePoints($client_number, $amount, $activity_id, $transaction = null, $points = null, $action)
    {
        if (!isset($client_number)) {
            return;
        }
        if (!isset($amount) || !isset($activity_id)) {
            return ["message" => "Invalid data received"];
        }
        $activity = Activity::find($activity_id);
        if (!isset($activity)) {
            return ["message" => "We are unable to find this activity"];
        }
        $client = points::where("client_number", '=', $client_number)->get();

        $client = ($client[0] ?? null);
        $percent = $activity->points;
        $client_points = ($amount * $percent) / 100;

        if ($transaction != null && strtolower($transaction) == 'consommation' && $points != null) {
            $client_points = $points;
            $newClient = [
                "id" => $client->id,
                "client_number" => $client_number,
                "points" => $client->points - $points,
                "points_consomes" => $client->points_consomes + $points
            ];
            $client->update($newClient);
            PointsHistoryController::saveHistory($activity_id, $amount, $client_points, $transaction, $client_number, $action);
            return $newClient;
        }

        if (isset($client)) {
            // print_r('client exists');
            $newClient = [
                "id" => $client->id,
                "client_number" => $client_number,
                "points" => $client->points + $client_points
            ];
            $client->update($newClient);
        } else {
            // print_r('client does not exists');
            $newClient = [
                "client_number" => $client_number,
                "points" => $client_points
            ];
            points::create($newClient);
        }
        PointsHistoryController::saveHistory($activity_id, $amount, $client_points, 'Octroi', $client_number, $action);
        return $newClient;
    }

    static public function getClientPoints($client_number)
    {
        $client = points::where("client_number", '=', $client_number)->get();
        // ->where('activity_id', '=', $activity_id)
        return $client[0] ?? [];
    }

    static public function savePointConfig(Request $request, $id = null)
    {
        if (isset($id)) {
            $points = PointsConfig::where('id', '=', $id);
            $updatedData = $points::update($request->all);
            return $updatedData;
        }
        $pointConfig = PointsConfig::create($request->all());
        return $pointConfig;
    }

    static public function getPointConfig(Request $request)
    {
        $pointConfig = PointsConfig::all();
        return $pointConfig;
    }
}
