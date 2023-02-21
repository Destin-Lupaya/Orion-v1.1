<?php

namespace App\Http\Controllers;

use App\Models\Amortissement;
use App\Http\Requests\StoreAmortissementRequest;
use App\Http\Requests\UpdateAmortissementRequest;

class AmortissementController extends Controller
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
     * @param  \App\Http\Requests\StoreAmortissementRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreAmortissementRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Amortissement  $amortissement
     * @return \Illuminate\Http\Response
     */
    public function show(Amortissement $amortissement)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\Amortissement  $amortissement
     * @return \Illuminate\Http\Response
     */
    public function edit(Amortissement $amortissement)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateAmortissementRequest  $request
     * @param  \App\Models\Amortissement  $amortissement
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateAmortissementRequest $request, Amortissement $amortissement)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Amortissement  $amortissement
     * @return \Illuminate\Http\Response
     */
    public function destroy(Amortissement $amortissement)
    {
        //
    }
}
