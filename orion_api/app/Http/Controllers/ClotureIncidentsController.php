<?php

namespace App\Http\Controllers;

use App\Http\Requests\Storecloture_incidentsRequest;
use App\Http\Requests\Updatecloture_incidentsRequest;
use App\Models\cloture_incidents;
use Illuminate\Http\Request;

class ClotureIncidentsController extends Controller
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
     * @param  \App\Http\Requests\Storecloture_incidentsRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $incident = cloture_incidents::create($request->all());
        return $incident;
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\cloture_incidents  $cloture_incidents
     * @return \Illuminate\Http\Response
     */
    static public function show($cloture_id)
    {
        $data = cloture_incidents::where('cloture_account_id', '=', $cloture_id);
        var_dump($data);
        return $data;
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\cloture_incidents  $cloture_incidents
     * @return \Illuminate\Http\Response
     */
    public function edit(cloture_incidents $cloture_incidents)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\Updatecloture_incidentsRequest  $request
     * @param  \App\Models\cloture_incidents  $cloture_incidents
     * @return \Illuminate\Http\Response
     */
    public function update(Updatecloture_incidentsRequest $request, cloture_incidents $cloture_incidents)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\cloture_incidents  $cloture_incidents
     * @return \Illuminate\Http\Response
     */
    public function destroy(cloture_incidents $cloture_incidents)
    {
        //
    }

    static public function getByCloture($cloture_id)
    {
        $data = cloture_incidents::where('cloture_account_id', '=', $cloture_id)->get();
        // var_dump($data);
        return $data;
    }
}
