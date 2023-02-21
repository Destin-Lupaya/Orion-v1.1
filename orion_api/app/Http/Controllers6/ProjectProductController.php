<?php

namespace App\Http\Controllers;

use App\Models\ProjectProduct;
use App\Http\Requests\StoreProjectProductRequest;
use App\Http\Requests\UpdateProjectProductRequest;

class ProjectProductController extends Controller
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
     * @param  \App\Http\Requests\StoreProjectProductRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreProjectProductRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\ProjectProduct  $projectProduct
     * @return \Illuminate\Http\Response
     */
    public function show(ProjectProduct $projectProduct)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\ProjectProduct  $projectProduct
     * @return \Illuminate\Http\Response
     */
    public function edit(ProjectProduct $projectProduct)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateProjectProductRequest  $request
     * @param  \App\Models\ProjectProduct  $projectProduct
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateProjectProductRequest $request, ProjectProduct $projectProduct)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\ProjectProduct  $projectProduct
     * @return \Illuminate\Http\Response
     */
    public function destroy(ProjectProduct $projectProduct)
    {
        //
    }
}
