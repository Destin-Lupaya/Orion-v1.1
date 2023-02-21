<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreCautionModelRequest;
use App\Http\Requests\UpdateCautionModelRequest;
use App\Models\Account;
use App\Models\CautionHistory;
use App\Models\CautionModel;
use Illuminate\Http\Request;

class CautionModelController extends Controller
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
     * @param  \App\Http\Requests\StoreCautionModelRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $caution = CautionModelController::saveCaution($request->all());
        return $caution;
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\CautionModel  $cautionModel
     * @return \Illuminate\Http\Response
     */
    public function show(CautionModel $cautionModel)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\CautionModel  $cautionModel
     * @return \Illuminate\Http\Response
     */
    public function edit(CautionModel $cautionModel)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdateCautionModelRequest  $request
     * @param  \App\Models\CautionModel  $cautionModel
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateCautionModelRequest $request, CautionModel $cautionModel)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\CautionModel  $cautionModel
     * @return \Illuminate\Http\Response
     */
    public function destroy(CautionModel $cautionModel)
    {
        //
    }


    static public function SaveCautionHistory($data)
    {
        if (!isset($data['external_clients_id']) || !isset($data['activity_id']) || !isset($data['user_id']) || !isset($data['amount'])) {
            return null;
        }
        $cautionHistory = [
            "activity_id" => $data['activity_id'],
            "external_clients_id" => $data['external_clients_id'],
            "account_id" => $data['account_id'],
            "amount" => $data['amount'],
            "type_operation" => $data['type_operation'],

        ];
        CautionHistory::create($cautionHistory);
    }

    static public function saveCaution($data)
    {
        $caution = CautionModel::where('external_clients_id', '=', $data['external_clients_id'])->get();
        // return $caution;
        $motif = 'Consommation';
        if (count($caution) > 0) {
            $oldAmount = $caution[0]['amount'];
            if (strtolower($data['type_operation']) == 'consommation') {
                $oldAmount -= $data['amount'];
            } else {
                $oldAmount += $data['amount'];
            }
            // $caution[0]['amount'] = $oldAmount;
            $caution[0]->update([
                'id' => $caution[0]['id'],
                'external_clients_id' => $data['external_clients_id'],
                'amount' => $oldAmount,
            ]);
            $userAccount = Account::find($data['account_id']);

            $usdAmount = strtolower($data['currency']) == 'usd' ? $userAccount->sold_cash_usd + $data['amount'] : $userAccount->sold_cash_usd;
            $cdfAmount = strtolower($data['currency']) == 'cdf' ? $userAccount->sold_cash_cdf + $data['amount'] : $userAccount->sold_cash_cdf;
            // print_r($usdAmount);
            // print_r($cdfAmount);
            $userAccount->update(["id" => $userAccount->id, "sold_cash_usd" => $usdAmount, "sold_cash_cdf" => $cdfAmount]);
            CautionHistory::create([
                'activity_id' => $data['activity_id'],
                'account_id' => $data['account_id'],
                'external_clients_id' => $data['external_clients_id'],
                'amount' => $data['amount'],
                'currency' => $data['currency'],
                'motif' => strtolower($data['type_operation']) == 'consommation' ? 'Consommation' : $data['motif'] ?? 'R.A.S',
                'type_operation' => $data['type_operation'],
            ]);
            return $userAccount;
        }
        $caution = CautionModel::create([
            'external_clients_id' => $data['external_clients_id'],
            'amount' => $data['amount'],
        ]);
        CautionHistory::create([
            'activity_id' => $data['activity_id'],
            'account_id' => $data['account_id'],
            'external_clients_id' => $data['external_clients_id'],
            'amount' => $data['amount'],
            'currency' => $data['currency'],
            'motif' => $data['motif'],
            'type_operation' => $data['type_operation'],
        ]);
        return $caution;
    }
}
