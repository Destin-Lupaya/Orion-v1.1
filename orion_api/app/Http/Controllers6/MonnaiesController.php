<?php

namespace App\Http\Controllers;

use App\Models\Monnaies;
use App\Http\Requests\StoreMonnaiesRequest;
use App\Http\Requests\UpdateMonnaiesRequest;

class MonnaiesController extends Controller
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
     * @param  \App\Http\Requests\StoreMonnaiesRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreMonnaiesRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Monnaies  $monnaies
     * @return \Illuminate\Http\Response
     */
    public function show(Monnaies $monnaies)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\Monnaies  $monnaies
     * @return \Illuminate\Http\Response
     */
    public function edit(Monnaies $monnaies)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateMonnaiesRequest  $request
     * @param  \App\Models\Monnaies  $monnaies
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateMonnaiesRequest $request, Monnaies $monnaies)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Monnaies  $monnaies
     * @return \Illuminate\Http\Response
     */
    public function destroy(Monnaies $monnaies)
    {
        //
    }
}
