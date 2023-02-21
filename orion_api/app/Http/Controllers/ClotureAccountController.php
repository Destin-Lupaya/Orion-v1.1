<?php

namespace App\Http\Controllers;

use App\Http\Resources\ClotureResource;
use App\Models\Account;
use App\Models\Billetage;
use App\Models\ClotureAccount;
use Illuminate\Http\Request;

class ClotureAccountController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $list = collect(ClotureAccount::all());
        $data = $list->map(function ($item, $key) {
            return $this->show($item);
        });
        $res = $data->map(function ($cloture, $collection) {
            // print_r($cloture->id);
            $incidents = ClotureIncidentsController::getByCloture($cloture->id);
            $activities = ClotureActivityController::getClosingActivities($cloture->id);
            // print_r(json_encode($activities));
            // array_push($cloture, [
            //     "incidents" => $incidents,
            //     "activities" => 'test'
            // ]);
            $cloture['incidents'] = $incidents;
            $cloture['activities'] = $activities;
            return $cloture;
        });
        return $res;
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $cloture = ClotureAccount::create($request->cloture);
        BilletageController::saveBilletage($cloture['id'], $request->billetage);
        ClotureActivityController::saveClosingActivities($request->activities, $cloture['id']);
        return $cloture;
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\ClotureAccount $cloture
     * @return \Illuminate\Http\Response
     */
    public function show($cloture)
    {

        return new ClotureResource($cloture); // ClotureAccount::find(ClotureAccount $cloture);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $account =  ClotureAccount::find($id);
        $account->update($request->all());

        // return $account;

        $data = (array) $request->all();
        $status = 400;


        /*
            checking if any data wasn't send, if note
            Yes (true) -> Quite the function
        */
        if (!$data) :

            $response = ["message" => "no data was sent"];
            return response()->json($response, $status);

        endif;

        /*
            checking if the 'Demand' status is accepted
            Yes (true) -> update the account or the activity affected by it
            No (false) -> update only the 'Demand'
        */
        if (
            strtolower($data['cloture']['status']) == 'accepted'
        ) :


            /*
                checking if the the 'Account1' and 'Account2' was send
                Yes (true) -> update the account or the activity affected by it
            */
            if (
                isset($data['account1']) &&
                isset($data['account2'])
            ) :

                $cloture = ClotureAccount::find($id);
                $cloture->update($data['cloture']);

                $account1 = Account::find($data['account1']['id']);
                $account1->update($data['account1']);

                $account2 = Account::find($data['account2']['id']);
                $account2->update($data['account2']);

                ClotureActivityController::updateClosingActivities($data['encloseActivities']);
                AccountActictyController::updateMultiple($data['accountActivities']['senderActivities']);
                AccountActictyController::updateMultiple($data['accountActivities']['movingActivities']);
                AccountActictyController::updateMultiple($data['accountActivities']['receiverActivities']);

                $response = ['message' => "Success", 'account1' => $account1, 'account2' => $account2, 'cloture' => $cloture];
                $status = 200;
                BilletageController::updateBilletage($data['billetage']);
                return response()->json($response, $status);


            /*
                checking if the the 'Account_activity_1' and 'Account_activity_2' was send
                Yes (true) -> update the account or the activity affected by it
            */
            else :


                $response = ['message' => "fail to update neither account or cloture  which was send"];

                return response()->json($response, $status);

            endif;

        /*
            checking the else the the 'Demand' status is accepted
            Yes (true) -> update the account or the activity affected by it
            No (false) -> update only the 'Demand'
        */
        else :

            $cloture = ClotureAccount::find($id);
            $cloture->update($data['cloture']);

            $status = 200;

            $response = ['message' => "Success", 'cloture' => $cloture];

            return response()->json($response, $status);

        endif;


        /*
            if the type accepted was send nor accounts or account_activities
            return a fail
        */
        $response = ['message' => "fail to update neither account or cloture  which was send"];

        return response()->json($response, $status);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        return ClotureAccount::destroy($id);
    }
}
