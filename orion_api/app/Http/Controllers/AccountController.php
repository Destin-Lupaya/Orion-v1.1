<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\AccountActivity;
use Exception;
use GuzzleHttp\Promise\Create;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;

class AccountController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Account::join('users', 'accounts.users_id', '=', 'users.id')
            ->get(['users.names', 'users.role', 'accounts.*']);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $data = (array) $request->all();
        $status = 400;

        if (!isset($data['account'])) {
            $response =  ["message" => "the data for account wasn't sent"];
            return response()->json($response, $status);
        }

        if (!isset($data['activities'])) {
            $response = ["message" => "the data for activity wasn't sent"];
            return response()->json($response, $status);
        }



        $account = $data['account'];
        $activities = array();

        $accountExist =  Account::where('users_id', '=', $account['users_id'])->get();

        if (isset($accountExist[0]['users_id'])) {

            $status = 409;

            $response = array("message" => "This user have already an account", "account" => $accountExist);
            return response()->json($response, $status);
        }

        try {
            $account =  Account::create($account);
        } catch (Exception $exception) {

            $account = false;
        }



        if (!isset($account['id'])) {

            $response = ["message" => "bad request"];
            return response()->json($response, $status);
        }

        foreach ($data['activities'] as $activity) {

            $activity["account_id"] = $account['id'];
            array_push($activities, $activity);
        }

        try {

            $activity = AccountActivity::insert($activities);
        } catch (Exception $exception) {

            $activity = false;
        }

        if ($activity == true) {

            $account = Account::where('accounts.id', '=', $account->id)
                ->join('users', 'accounts.users_id', '=', 'users.id')
                ->get(['users.names', 'accounts.*']);

            $status = 200;
            $response = $account;

            return response()->json($response, $status);
        } else {

            Account::destroy($account['id']);
            $response = ["message" => "bad request"];
            return response()->json($response, $status);
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $accountActivity = AccountActivity::where('account_id', '=', $id)->where('statusActive', '=', '1')
            ->join('activities', 'account_activities.activity_id', '=', 'activities.id')
            ->get(['activities.id as activity_id', 'activities.avatar', 'account_activities.*', 'activities.name']);

        return
            [
                "account" => Account::join('users', 'accounts.users_id', '=', 'users.id')
                    ->get(['users.names', 'users.role', 'accounts.*'])->find($id),
                "activities" => $accountActivity
            ];
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
        $account = Account::find($id);
        $account->update($request->all());

        return $account;
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        return Account::destroy($id);
    }
}
