<?php

use App\Http\Controllers\AccountActictyController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\UsersController;


use App\Http\Controllers\AccountController;
use App\Http\Controllers\ActivityController;
use App\Http\Controllers\BilletageController;
use App\Http\Controllers\BranchController;
use App\Http\Controllers\CautionModelController;
use App\Http\Controllers\ClotureAccountController;
use App\Http\Controllers\ClotureIncidentsController;
use App\Http\Controllers\DemandController;
use App\Http\Controllers\ExternalClientController;
use App\Http\Controllers\FactureController;
use App\Http\Controllers\TransacrtionController;
use App\Http\Controllers\PointsController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('/user/login', [UsersController::class, 'login']);

/*
|------------------------------------------------------------
|API Routes for User details
|------------------------------------------------------------
 */
Route::resource('/users', UsersController::class);


/*
|------------------------------------------------------------
|API Routes for Users operation
|------------------------------------------------------------
 */
Route::resource('/branch', BranchController::class);
Route::resource('/activity', ActivityController::class);
Route::resource('/account', AccountController::class);
Route::resource('/demande', DemandController::class);
Route::resource('/transaction', TransacrtionController::class);
Route::resource('/facture', FactureController::class);
Route::resource('/accountactivity', AccountActictyController::class);
// Route::resource('/points', PointsController::class);
Route::resource('/billetage', BilletageController::class);
Route::post('/add-billetage', [BilletageController::class, 'saveBilletage']);
Route::post('/add-incident', [ClotureIncidentsController::class, 'store']);


Route::get('/trans_account/{id}', [TransacrtionController::class, 'transAccount']);
Route::get('/trans_pret/pret/{accountID?}', [TransacrtionController::class, 'getPretEmprunt']);
Route::get('/branch_activity/{data}', [ActivityController::class, 'reportBranch']);
Route::resource('/cloture', ClotureAccountController::class);

// Point config
Route::post('/add-point-config', [PointsController::class, 'savePointConfig']);
Route::put('/add-point-config/{id}', [PointsController::class, 'savePointConfig']);
Route::get('/get-point-config', [PointsController::class, 'getPointConfig']);
Route::get('/get-client-point/{client_number}', [PointsController::class, 'getClientPoints']);

// External client
Route::resource('/external-client', ExternalClientController::class);
Route::resource('/caution', CautionModelController::class);
Route::get('/stats', [TransacrtionController::class, 'getStats']);
Route::get('/stats-count', [TransacrtionController::class, 'getCounts']);

Route::group(
    [
        // 'namespace' => 'App\Http\Controllers\UsersController',
        'middleware' => ['auth:sanctum']
    ],
    function () {
        Route::resource('/branches', BranchController::class);
    }
);
// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
// return $request->user();
// });
