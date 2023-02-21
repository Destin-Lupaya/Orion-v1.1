<?php

namespace App\Http\Controllers;

use App\Models\FactureDetail;
use App\Http\Requests\StoreFactureDetailRequest;
use App\Http\Requests\UpdateFactureDetailRequest;

class FactureDetailController extends Controller
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
     * @param  \App\Http\Requests\StoreFactureDetailRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreFactureDetailRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\FactureDetail  $factureDetail
     * @return \Illuminate\Http\Response
     */
    public function show(FactureDetail $factureDetail)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\FactureDetail  $factureDetail
     * @return \Illuminate\Http\Response
     */
    public function edit(FactureDetail $factureDetail)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateFactureDetailRequest  $request
     * @param  \App\Models\FactureDetail  $factureDetail
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateFactureDetailRequest $request, FactureDetail $factureDetail)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\FactureDetail  $factureDetail
     * @return \Illuminate\Http\Response
     */
    public function destroy(FactureDetail $factureDetail)
    {
        //
    }
}
