<?php

namespace App\Http\Controllers;

use App\Models\taux;
use App\Http\Requests\StoretauxRequest;
use App\Http\Requests\UpdatetauxRequest;

class TauxController extends Controller
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
     * @param  \App\Http\Requests\StoretauxRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoretauxRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\taux  $taux
     * @return \Illuminate\Http\Response
     */
    public function show(taux $taux)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\taux  $taux
     * @return \Illuminate\Http\Response
     */
    public function edit(taux $taux)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdatetauxRequest  $request
     * @param  \App\Models\taux  $taux
     * @return \Illuminate\Http\Response
     */
    public function update(UpdatetauxRequest $request, taux $taux)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\taux  $taux
     * @return \Illuminate\Http\Response
     */
    public function destroy(taux $taux)
    {
        //
    }
}
