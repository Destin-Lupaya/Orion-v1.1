<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Users;

class UsersController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Users::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        return Users::create($request->all());
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        return Users::find($id);
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
        $user =  Users::find($id);
        $user->update($request->all());

        return $user;
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }

    /**
     * look for a specific resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function login(Request $request)
    {
        $userForm = (array) $request->all();

        $email = isset($userForm['email']) ? $userForm['email'] : '';
        $psw = isset($userForm['psw']) ? $userForm['psw'] : '';

        $user = Users::where('email', '=', $email)->orwhere('telephone', '=', $email)->get();

        $status = "404";

        if (count($user) > 0) {

            if ($user[0]['psw'] == $psw) {
                if ($user[0]['statusActive'] == 0) {
                    return response()->json(["message" => "Votre compte a été désactivé, veuillez contacter votre administrateur"], 403);
                }

                $status = "200";
                $user = $user[0];
                $account = Users::find($user['id'])->getAccount;

                $authToken = $user->createToken('auth-token')->plainTextToken;

                $response = ['user' => $user, 'account' => $account, 'access-token' => $authToken];
            } else {

                $response = ["message" => 'wrong password'];
            }
        } else {

            $response = ["message" => 'wrong email ou telephone'];
        }

        return response()->json($response, $status);
    }
}
