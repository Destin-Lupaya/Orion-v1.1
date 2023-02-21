<?php

namespace App\Http\Controllers;

use App\Models\SousCompteDebuts;
use App\Http\Requests\StoreSousCompteDebutsRequest;
use App\Http\Requests\UpdateSousCompteDebutsRequest;

class SousCompteDebutsController extends Controller
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
     * @param  \App\Http\Requests\StoreSousCompteDebutsRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreSousCompteDebutsRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\SousCompteDebuts  $sousCompteDebuts
     * @return \Illuminate\Http\Response
     */
    public function show(SousCompteDebuts $sousCompteDebuts)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\SousCompteDebuts  $sousCompteDebuts
     * @return \Illuminate\Http\Response
     */
    public function edit(SousCompteDebuts $sousCompteDebuts)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateSousCompteDebutsRequest  $request
     * @param  \App\Models\SousCompteDebuts  $sousCompteDebuts
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateSousCompteDebutsRequest $request, SousCompteDebuts $sousCompteDebuts)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\SousCompteDebuts  $sousCompteDebuts
     * @return \Illuminate\Http\Response
     */
    public function destroy(SousCompteDebuts $sousCompteDebuts)
    {
        //
    }
}
