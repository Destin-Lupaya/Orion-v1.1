<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\AccountActivity;
use App\Models\Transacrtion;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\PointsController;

class TransacrtionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Transacrtion::all();
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

        $transTable = "transaction_" . $data['activity']['activity_id'];
        if (!isset($data['account']) && !isset($data['points'])) {
            $status = 403;
            $response = array("message" => "No payment method was supplied");
            return response()->json($response, $status);
        }
        // return $transTable;
        $trans =  DB::table($transTable)->insert($data['trans']);

        $activity = AccountActivity::find($data['activity']['id']);
        $activity->update($data['activity']);

        if (isset($data['account'])) {
            $account = Account::find($data['account']['id']);
            $account->update($data['account']);
        }
        $transaction = null;
        if (isset($data['points'])) {
            $transaction = 'Consommation';
            $used_points = $data['points']['point'];
        }
        $points = PointsController::calculatePoints($data['trans']['client_number'], $data['trans']['amount'], $data['activity']['activity_id'], $transaction, $used_points ?? null, $data['trans']['type_operation']);

        if (isset($data['caution'])) {
            $caution = CautionModelController::saveCaution($data['caution']);
        }
        // $caution = CautionModelController::saveCaution($data['caution']);

        return ['trans' => $trans, 'activity' => $activity, 'account' => $account ?? null, 'points' => $points ?? null, "caution" => $caution ?? null];
    }

    /**
     * Display the specified resource.
     *
     * @param  string  $id {"activity_id":"{id}"}
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {

        $id = json_decode($id, true);

        $transTable = "transaction_" . $id['activity_id'];
        // return Transacrtion::find($id);

        $trans =  DB::table($transTable)->get();

        return $trans;
    }

    /**
     * Display the specified resource.
     *
     * @param  string  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $activity_id = json_decode($id, true);
        $activity_id = $activity_id['activity_id'];

        $transTable = "transaction_" . $activity_id;

        $data =  DB::table($transTable)
            ->where('id', $request->id)
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
        return Transacrtion::destroy($id);
    }

    /**
     * transaction for the specified resource (account) from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function transAccount($id)
    {
        return Transacrtion::where('account_id', '=', $id)
            ->get();
    }


    static public function getCounts()
    {
        $res = DB::select("SELECT (SELECT COUNT(*) FROM external_clients) countClient, (SELECT COUNT(*) FROM demands) countDemands, (SELECT COUNT(*) FROM cautions) countCaution");
        return $res[0];
    }
    static public function getStats($branchID = null, $accountID = null)
    {
        $duration = 30;
        $tables = DB::select("SHOW TABLES");
        $neededTables = array_map(function ($item) {
            return $item->Tables_in_okapishop_db_api;
        }, $tables);
        $transTables = array_filter($neededTables, function ($item) {
            return str_contains($item, 'transaction');
        });
        // print_r(($transTables));
        $pureTables = [];
        foreach ($transTables as $key => $value) {
            array_push($pureTables, $value);
        }
        $statsData = [];
        // Getting the first activiyy ID for the base query for the first table
        $baseActivityID = substr($pureTables[0], -1);
        // Building the cashIn base query for the first table
        $baseCashInQuery = 'SELECT sum(amount) amount, Date(dateTrans) date FROM transaction_' . $baseActivityID . ' INNER JOIN activities ON activities.id=' . $baseActivityID . ' WHERE Date(dateTrans) > now() - INTERVAL ' . $duration . ' day AND Date(dateTrans) < now() AND transaction_' . $baseActivityID . '.type_operation LIKE CONCAT("%", activities.cashIn, "%") group by Date(dateTrans)';

        // Building the cashOut babse query for the first table
        $baseCashOutQuery = 'SELECT sum(amount) amount, Date(dateTrans) date FROM transaction_' . $baseActivityID . ' INNER JOIN activities ON activities.id=' . $baseActivityID . ' WHERE Date(dateTrans) > now() - INTERVAL ' . $duration . ' day AND Date(dateTrans) < now() AND transaction_' . $baseActivityID . '.type_operation LIKE CONCAT("%", activities.cashOut, "%") group by Date(dateTrans)';

        // Initiatiing requests (cashIn and cashOut)
        $reqCashIn = $baseCashInQuery;
        $reqCashOutQuery = $baseCashOutQuery;

        // Building the main queries based on transaction tables
        for ($i = 1; $i < count($pureTables); $i++) {
            // Getting activityID for each table
            $activityID = substr($pureTables[$i], -1);
            // Building main query for the cashIn data
            $reqCashIn .= ' UNION ALL SELECT sum(amount) amount, Date(dateTrans) date FROM `transaction_' . $activityID . '` INNER JOIN activities ON activities.id=' . $activityID . ' WHERE Date(dateTrans) > now() - INTERVAL ' . $duration . ' day AND Date(dateTrans) < now() AND transaction_' . $activityID . '.type_operation LIKE CONCAT("%", activities.cashIn, "%") group by Date(dateTrans)';



            // BUilding the main query for the cashOut data
            $reqCashOutQuery .= ' UNION ALL SELECT sum(amount) amount, Date(dateTrans) date FROM `transaction_' . $activityID . '` INNER JOIN activities ON activities.id=' . $activityID . ' WHERE Date(dateTrans) > now() - INTERVAL ' . $duration . ' day AND Date(dateTrans) < now() AND transaction_' . $activityID . '.type_operation LIKE CONCAT("%", activities.cashOut, "%") group by Date(dateTrans)';

            // print_r(json_encode($res));

        }
        $res = DB::select($reqCashIn);
        $resCashOut = DB::select($reqCashOutQuery);
        array_push($statsData, [
            // "activityID" => $activityID,
            "cashIn" => $res,
            "cashOut" => $resCashOut
        ]);
        print_r(json_encode($statsData));
        if (isset($branchID)) {
        }

        if (isset($accountID)) {
        }
    }

    static public function getPretEmprunt($accountID = null)
    {
        // $duration = 30;
        $tables = DB::select("SHOW TABLES");
        $neededTables = array_map(function ($item) {
            return $item->Tables_in_okapishop_db_api;
        }, $tables);
        $transTables = array_filter($neededTables, function ($item) {
            return str_contains($item, 'transaction');
        });
        // print_r(($accountID));
        $pureTables = [];
        foreach ($transTables as $key => $value) {
            array_push($pureTables, $value);
        }
        $maxAccountID = 0;
        $minAccountID = 0;
        if ($accountID == null) {
            $maxAccountID = PHP_INT_MAX;
            $minAccountID = 0;
        } else {
            $maxAccountID = $accountID;
            $minAccountID = $accountID;
        }
        $statsData = [];
        // Getting the first activiyy ID for the base query for the first table
        $baseActivityID = substr($pureTables[0], -1);
        // Building the cashIn base query for the first table
        $baseQuery = "SELECT transaction_" . $baseActivityID . ".id, refkey, type_operation, type_payment,type_devise, amount, quantity, account_id, external_clients.name, external_clients.phone FROM `transaction_" . $baseActivityID . "` LEFT JOIN external_clients ON external_clients.id=transaction_" . $baseActivityID . ".client_number WHERE status='pending' AND (transaction_" . $baseActivityID . ".type_payment LIKE '%pret%' OR transaction_" . $baseActivityID . ".type_payment LIKE '%emprunt%') AND account_id>=" . $minAccountID . " AND account_id<=" . $maxAccountID . "";
        // print_r($baseQuery);
        // Initiatiing requests (cashIn and cashOut)
        $reqCashIn = $baseQuery;

        // Building the main queries based on transaction tables
        for ($i = 1; $i < count($pureTables); $i++) {
            // Getting activityID for each table
            $activityID = substr($pureTables[$i], -1);
            // Building main query for the cashIn data
            $reqCashIn .= " UNION ALL SELECT transaction_" . $activityID . ".id, refkey, type_operation, type_payment,type_devise, amount, quantity, account_id, external_clients.name, external_clients.phone FROM `transaction_" . $activityID . "` LEFT JOIN external_clients ON external_clients.id=transaction_" . $activityID . ".client_number WHERE status='pending' AND (transaction_" . $activityID . ".type_payment LIKE '%pret%' OR transaction_" . $activityID . ".type_payment LIKE '%emprunt%') AND account_id>=" . $minAccountID . " AND account_id<=" . $maxAccountID . "";
        }
        $res = DB::select($reqCashIn);
        // array_push($statsData, [
        //     // "activityID" => $activityID,
        //     "cashIn" => $res,
        //     // "cashOut" => $resCashOut
        // ]);
        print_r(json_encode($res));
    }
}
