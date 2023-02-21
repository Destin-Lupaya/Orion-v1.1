<?php

namespace App\Http\Controllers;

use App\Models\ActiviteInput;
use App\Models\Activity;
use App\Models\Branch;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ActivityController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Activity::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $fileName = time().'.'.$request->file->extension();

        $request->file->move(public_path('/clientfiles'), $fileName);
        $url = '/clientfiles/'.$fileName;

        $inputs = $request->inputs;

        // $activity = $request->activity;

        $data = [
            'name' => $request->name,
            'description' => $request->description,
            'avatar' => $url,
            'statusActive' => $request->statusActive,
            'cashIn' => $request->cashIn,
            'cashOut' => $request->cashOut,
            'hasStock' => $request->hasStock,
            'hasNegativeSold' => $request->hasNegativeSold,
            'points' => $request->points,
            'users_id' => $request->users_id
        ];

        // return json_encode($data);

        /* Store $fileName name in DATABASE from HERE */
        $activity = Activity::create($data);

        $activity_id = $activity->id;

        $inputs = json_decode($inputs, true);

        $newInputs = array();

        $count = 0;

        DB::select("CALL newActivity('facture_".$activity_id."', 'transaction_".$activity_id."' )");

        foreach($inputs as $input){

            $count = $count + 1;

            $newInput = array('activity_id' => $activity_id, 'designation' => $input['designation'], 'web' => $input['web']);
            array_push($newInputs, $newInput);

            DB::select("ALTER TABLE facture_$activity_id ADD col_$count varchar(255);");
            DB::select("ALTER TABLE transaction_$activity_id ADD col_$count varchar(255);");

        }

        $inputs = ActiviteInput::insert($newInputs);

        return ['data'=>"success You have successfully file uplaod. file $fileName", 'save'=>$activity];
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $activity =  Activity::find($id);
        $inputs = Activity::find($id)->getActivityInput;

        return ['activity' => $activity, 'inputs' => $inputs];
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
        $activity = Activity::find($id);
        $activity->update($request->all());

        return $activity;
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        return Activity::destroy($id);
    }


     /**
     * Display the specified resource.
     *
     * @param  string  $data
     * @return \Illuminate\Http\Response
     */
    public function reportBranch($data)
    {
        $data = json_decode($data, true);

        if(!isset($data['branch_id']) && !isset($data['activity_id'])){

            return ["message" => "Please send activity_id and branch_id"];
        }

        $id = $data['branch_id'];
        $account = Branch::find($id);

        $activity = Activity::find($data['activity_id']);

        if(!$account){
            return ["message" => " branch_id : ". $id." doesn't exist "];
        }

        if(!$activity){
            return ["message" => " activity_id : ".$data['activity_id']." doesn't exist "];
        }

        $accounts = Branch::find($id)->getAccount;
        $inputs = Activity::find($data['activity_id'])->getActivityInput;


        $account_ids = [];

        foreach($accounts as $account){
            array_push($account_ids, $account["id"]);
        }

        $transTable = "transaction_".$data['activity_id'];

        $data = DB::table($transTable)
        ->whereIn("account_id", $account_ids)
        ->get();



        return ['inputs' => $inputs, 'trans' => $data];
    }
}
