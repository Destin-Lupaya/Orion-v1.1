<?php

namespace App\Http\Controllers;

use App\Models\Demand;
use App\Models\Account;
use App\Models\AccountActivity;
use App\Models\Transacrtion;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use phpDocumentor\Reflection\PseudoTypes\LowercaseString;

class DemandController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Demand::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        return Demand::create($request->all());
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        return Demand::find($id);
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
        $data = (array) $request->all();
        $status = 400;

    
        /*
            checking if any data wasn't send, if note
            Yes (true) -> Quite the function
        */
        if(!$data):
            
            $response = ["message"=> "no data was send"];
            return response()->json($response, $status);

        endif;

        /*
            checking if the 'Demand' status is accepted
            Yes (true) -> update the account or the activity affected by it
            No (false) -> update only the 'Demand'
        */
        if(
            strtolower($data['demand']['status']) == 'accepted' || 
            strtolower($data['demand']['status']) == 'paid'
            ):


            /*
                checking if the the 'Account1' and 'Account2' was send
                Yes (true) -> update the account or the activity affected by it
            */
            if( 
                isset($data['account1']) && 
                isset($data['account2']) 
                ):

                $demand = Demand::find($id);
                $demand->update($data['demand']);


                $account1 = Account::find($data['account1']['id']);
                $account1->update($data['account1']);

                $account2 = Account::find($data['account2']['id']);
                $account2->update($data['account2']);

                $response = ['message'=>"Success", 'account1'=> $account1, 'account2'=>$account2, 'demand'=>$demand];
                
                $status = 200;

                return response()->json($response, $status);


            /*
                checking if the the 'Account_activity_1' and 'Account_activity_2' was send
                Yes (true) -> update the account or the activity affected by it
            */
            elseif( 
                isset($data['account_activity1']) && 
                isset($data['account_activity2']) &&
                isset($data['activity_id'])
                ):

                $demand = Demand::find($id);
                $demand->update($data['demand']);

                $transTable = "transaction_".$data['activity_id'];
                    
                $acctivity1 = AccountActivity::find($data['account_activity1']['id']);
                $acctivity1->update($data['account_activity1']);

                $acctivity2 = AccountActivity::find($data['account_activity2']['id']);
                $acctivity2->update($data['account_activity2']);

                $trans1 = DB::table($transTable)->insert($data['trans1']);
                $trans2 = DB::table($transTable)->insert($data['trans2']);

                $response = ['message'=>"Success", 'trans'=> [$trans1, $trans2], 'activity1'=> $acctivity1, 'activity2'=>$acctivity2, 'demand'=>$demand];

                $status = 200;
                
                return response()->json($response, $status);

            endif;

        /*
            checking the else the the 'Demand' status is accepted
            Yes (true) -> update the account or the activity affected by it
            No (false) -> update only the 'Demand'
        */
        else:

            $demand = Demand::find($id);
            $demand->update($data['demand']);

            $status = 200;

            $response = ['message'=>"Success",'demand'=>$demand];

            return response()->json($response, $status);

        endif;


        /*
            if the type accepted was send nor accounts or account_activities
            return a fail
        */
        $response = ['message'=>"fail to update neither account or account_activity  which was send"];

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
        return Demand::destroy($id);
    }
}
