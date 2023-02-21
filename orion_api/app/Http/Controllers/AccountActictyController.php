<?php

namespace App\Http\Controllers;

use App\Models\AccountActivity;
use Illuminate\Http\Request;

class AccountActictyController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return AccountActivity::join('activities', 'account_activities.activity_id', '=', 'activities.id')
            ->get(['activities.id as activity_id', 'account_activities.*', 'activities.name']);
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
        $list = $data['data'];

        return AccountActivity::insert($list);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        return AccountActivity::find($id);
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
        $accountActivity = AccountActivity::find($id);
        $accountActivity->update($request->all());

        return $accountActivity;
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        return AccountActivity::destroy($id);
    }

    static public function updateMultiple($data)
    {
        for ($i = 0; $i < count($data); $i++) {
            // $data[$i]['cloture_id'] = $cloture_id;
            $result = AccountActivity::where('id', '=', $data[$i]['id'])->update($data[$i]);
        }
    }
}
