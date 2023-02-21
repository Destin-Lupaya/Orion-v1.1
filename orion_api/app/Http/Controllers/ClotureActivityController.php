<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreClotureActivityRequest;
use App\Http\Requests\UpdateClotureActivityRequest;
use App\Models\ClotureActivity;

class ClotureActivityController extends Controller
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

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \App\Http\Requests\StoreClotureActivityRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreClotureActivityRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\ClotureActivity  $clotureActivity
     * @return \Illuminate\Http\Response
     */
    public function show(ClotureActivity $clotureActivity)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\ClotureActivity  $clotureActivity
     * @return \Illuminate\Http\Response
     */
    public function edit(ClotureActivity $clotureActivity)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateClotureActivityRequest  $request
     * @param  \App\Models\ClotureActivity  $clotureActivity
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateClotureActivityRequest $request, ClotureActivity $clotureActivity)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\ClotureActivity  $clotureActivity
     * @return \Illuminate\Http\Response
     */
    public function destroy(ClotureActivity $clotureActivity)
    {
        //
    }

    static public function saveClosingActivities($data, $cloture_id)
    {
        $hasErrors = false;
        if (count($data) < 1) {
            return ['message' => "Empty data received", "status" => 403];
        }
        for ($i = 0; $i < count($data); $i++) {
            if (!isset($cloture_id) || !isset($data[$i]['activity_id']) || (!isset($data[$i]['amount_usd']) && !isset($data[$i]['amount_cdf']))) {
                $hasErrors = true;
            }
        }
        if ($hasErrors == true) {
            return ['message' => "Some data are invalid, please check", "status" => 403];
        }
        for ($i = 0; $i < count($data); $i++) {
            $data[$i]['cloture_id'] = $cloture_id;
            $result = ClotureActivity::create($data[$i]);
        }
        return ['message' => "Data saved", "status" => 200];
    }

    static public function updateClosingActivities($data)
    {
        $hasErrors = false;
        if (count($data) < 1) {
            return ['message' => "Empty data received", "status" => 403];
        }
        for ($i = 0; $i < count($data); $i++) {
            if (!isset($data[$i]['activity_id']) || (!isset($data[$i]['amount_usd']) && !isset($data[$i]['amount_cdf']))) {
                $hasErrors = true;
            }
        }
        if ($hasErrors == true) {
            return ['message' => "Some data are invalid, please check", "status" => 403];
        }
        for ($i = 0; $i < count($data); $i++) {
            // $data[$i]['cloture_id'] = $cloture_id;
            $result = ClotureActivity::where('id', '=', $data[$i]['id'])->update($data[$i]);
        }
        return ['message' => "Data saved", "status" => 200];
    }

    static public function getClosingActivities($cloture_id)
    {
        // print_r($cloture_id);
        $data = ClotureActivity::where('cloture_id', '=', $cloture_id)->join('activities', 'activity_id', '=', 'activities.id')->get(['activities.name', 'cloture_activities.*']);

        return $data;
    }
}
