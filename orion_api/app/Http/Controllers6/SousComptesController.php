<?php

namespace App\Http\Controllers;

use App\Models\sousComptes;
use App\Http\Requests\StoresousComptesRequest;
use App\Http\Requests\UpdatesousComptesRequest;

class SousComptesController extends Controller
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
     * @param  \App\Http\Requests\StoresousComptesRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoresousComptesRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\sousComptes  $sousComptes
     * @return \Illuminate\Http\Response
     */
    public function show(sousComptes $sousComptes)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\sousComptes  $sousComptes
     * @return \Illuminate\Http\Response
     */
    public function edit(sousComptes $sousComptes)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdatesousComptesRequest  $request
     * @param  \App\Models\sousComptes  $sousComptes
     * @return \Illuminate\Http\Response
     */
    public function update(UpdatesousComptesRequest $request, sousComptes $sousComptes)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\sousComptes  $sousComptes
     * @return \Illuminate\Http\Response
     */
    public function destroy(sousComptes $sousComptes)
    {
        //
    }
}
