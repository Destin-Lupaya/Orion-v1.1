<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreExternalClientRequest;
use App\Http\Requests\UpdateExternalClientRequest;
use App\Models\ExternalClient;
use Illuminate\Http\Request;

class ExternalClientController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return ExternalClient::leftjoin('cautions', 'cautions.external_clients_id', '=', 'external_clients.id')->leftjoin('points', 'points.client_number', '=', 'external_clients.phone')->get(['external_clients.*', 'cautions.amount as caution', 'points.points as pointsClient']);
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
     * @param  \App\Http\Requests\StoreExternalClientRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        // print_r(json_encode($request->all()));
        $client = ExternalClient::create($request->all());
        return response(["message" => 'Data saved', "data" => $client], 200);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\ExternalClient  $externalClient
     * @return \Illuminate\Http\Response
     */
    public function show(ExternalClient $externalClient)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\ExternalClient  $externalClient
     * @return \Illuminate\Http\Response
     */
    public function edit(ExternalClient $externalClient)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateExternalClientRequest  $request
     * @param  \App\Models\ExternalClient  $externalClient
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateExternalClientRequest $request, ExternalClient $externalClient)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\ExternalClient  $externalClient
     * @return \Illuminate\Http\Response
     */
    public function destroy(ExternalClient $externalClient)
    {
        //
    }
}
