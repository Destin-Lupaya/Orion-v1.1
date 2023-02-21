<?php

namespace App\Http\Controllers;

use App\Models\ProjectActivity;
use App\Http\Requests\StoreProjectActivityRequest;
use App\Http\Requests\UpdateProjectActivityRequest;

class ProjectActivityController extends Controller
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
     * @param  \App\Http\Requests\StoreProjectActivityRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreProjectActivityRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\ProjectActivity  $projectActivity
     * @return \Illuminate\Http\Response
     */
    public function show(ProjectActivity $projectActivity)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\ProjectActivity  $projectActivity
     * @return \Illuminate\Http\Response
     */
    public function edit(ProjectActivity $projectActivity)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateProjectActivityRequest  $request
     * @param  \App\Models\ProjectActivity  $projectActivity
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateProjectActivityRequest $request, ProjectActivity $projectActivity)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\ProjectActivity  $projectActivity
     * @return \Illuminate\Http\Response
     */
    public function destroy(ProjectActivity $projectActivity)
    {
        //
    }
}
