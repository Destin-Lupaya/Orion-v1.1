<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class FactureController extends Controller
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
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $facture = (array) $request->all();
        $fatureTable = 'facture_'.$facture['activity_id'];

        $newFacture = array_filter($facture, function($key){
            return 'activity_id' !== $key;
        }, ARRAY_FILTER_USE_KEY);

        return  DB::table($fatureTable)->insert($newFacture);
    }

    /**
     * Display the specified resource.
     *
     * @param  string  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $facture = json_decode($id, true);
        $factureTable = 'facture_'.$facture['activity_id'];

        return DB::table($factureTable)->get();

    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  string  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $facture = json_decode($id, true);
        $factureTable = 'facture_'.$facture['activity_id'];

        // return $request->all();

        $data =  DB::table($factureTable)
        ->where('id',$request->id)
        ->update($request->all());

        return $data;

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
