<?php

namespace App\Http\Controllers;

use App\Models\comptes;
use App\Http\Requests\StorecomptesRequest;
use App\Http\Requests\UpdatecomptesRequest;

class ComptesController extends Controller
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
     * @param  \App\Http\Requests\StorecomptesRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StorecomptesRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\comptes  $comptes
     * @return \Illuminate\Http\Response
     */
    public function show(comptes $comptes)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\comptes  $comptes
     * @return \Illuminate\Http\Response
     */
    public function edit(comptes $comptes)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdatecomptesRequest  $request
     * @param  \App\Models\comptes  $comptes
     * @return \Illuminate\Http\Response
     */
    public function update(UpdatecomptesRequest $request, comptes $comptes)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\comptes  $comptes
     * @return \Illuminate\Http\Response
     */
    public function destroy(comptes $comptes)
    {
        //
    }
}
