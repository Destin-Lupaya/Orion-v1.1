<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\AccountActivity;
use App\Models\Activity;
use App\Models\Branch;
use Illuminate\Http\Request;

class BranchController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Branch::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        return Branch::create($request->all());
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $branch = Branch::find($id);

        if(!$branch){
            return ["message" => " branch_id : ". $id." doesn't exist "];
        }

        $accounts = Account::where("branch_id", "=" , $id)
        ->join('users', 'accounts.users_id','=','users.id')
        ->get(['users.names', 'accounts.*']);;

        $account_ids = [];

        foreach($accounts as $account){
            array_push($account_ids, $account["id"]);
        }
        
        $activity = AccountActivity::whereIn("account_id", $account_ids)
        ->join('activities', 'account_activities.activity_id','=','activities.id')
        ->get(['account_activities.*', 'activities.name']);

        return ["branch" => $branch, "accounts" => $accounts, "account_activity" => $activity]; 
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
        $branch =  Branch::find($id);
        $branch->update($request->all()); 
        return $branch;
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        return Branch::destroy($id);
    }
}
