<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreBilletageRequest;
use App\Http\Requests\UpdateBilletageRequest;
use App\Models\Billetage;
use Illuminate\Http\Request;

class BilletageController extends Controller
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
     * @param  \App\Http\Requests\StoreBilletageRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //

        $response = BilletageController::saveBilletage($request->cloture_id, $request->data);
        return $response;
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Billetage  $billetage
     * @return \Illuminate\Http\Response
     */
    public function show(Billetage $billetage)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\Billetage  $billetage
     * @return \Illuminate\Http\Response
     */
    public function edit(Billetage $billetage)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateBilletageRequest  $request
     * @param  \App\Models\Billetage  $billetage
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateBilletageRequest $request, Billetage $billetage)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Billetage  $billetage
     * @return \Illuminate\Http\Response
     */
    public function destroy(Billetage $billetage)
    {
        //
    }

    static public function saveBilletage($cloture_id, $data)
    {
        if (!isset($cloture_id) || !isset($data)) {
            return ['message' => "Données invalides"];
        }
        $hasError = false;
        for ($i = 0; $i < count($data); $i++) {
            // print_r($data[$i]['billet']);
            if (!isset($data[$i]['billet']) || !isset($data[$i]['nombre'])) {
                $hasError = true;
                continue;
            }
            $data[$i]['cloture_account_id'] = $cloture_id;
        }
        if ($hasError == true) {
            return ['message' => "Certaines données sont invalides"];
        }
        Billetage::insert($data);
        return response('Data saved', 200);
    }

    static public function updateBilletage($data)
    {
        if (!isset($data)) {
            return ['message' => "Données invalides"];
        }
        $hasError = false;
        for ($i = 0; $i < count($data); $i++) {
            // print_r($data[$i]['billet']);
            if (!isset($data[$i]['billet']) || !isset($data[$i]['nombre'])) {
                $hasError = true;
                continue;
            }
        }
        if ($hasError == true) {
            return ['message' => "Certaines données sont invalides"];
        }
        for ($i = 0; $i < count($data); $i++) {
            $billetage = Billetage::find($data[$i]['id']);
            $billetage->update($data[$i]);
            // $account->update($request->all());
        }
        // Billetage::insert($data);
        return response('Data updated', 200);
    }

    static public function getBilletage($cloture_id)
    {
        $billetage = Billetage::where("cloture_account_id", '=', $cloture_id)->get();
        return $billetage;
    }
}
