<?php

namespace App\Http\Controllers;

use App\Models\Cloture;
use App\Http\Requests\StoreClotureRequest;
use App\Http\Requests\UpdateClotureRequest;

class ClotureController extends Controller
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
     * @param  \App\Http\Requests\StoreClotureRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreClotureRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Cloture  $cloture
     * @return \Illuminate\Http\Response
     */
    public function show(Cloture $cloture)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\Cloture  $cloture
     * @return \Illuminate\Http\Response
     */
    public function edit(Cloture $cloture)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateClotureRequest  $request
     * @param  \App\Models\Cloture  $cloture
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateClotureRequest $request, Cloture $cloture)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Cloture  $cloture
     * @return \Illuminate\Http\Response
     */
    public function destroy(Cloture $cloture)
    {
        //
    }
}
