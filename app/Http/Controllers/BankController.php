<?php

namespace App\Http\Controllers;

use App\User;

class BankController extends Controller
{
    public function test()
    {
        return response()->json(['all' => 1], 200);
    }

    /**
     * Retrieve the number of banks.
     *
     * @return Response
     */
    public function count()
    {
        $result = app('db')->select("SELECT count(*) as numberOfBanks FROM bank");
        return response()->json(['banks' => $result[0]->numberOfBanks], 200);
    }
    
    public function all()
    {
        try
        {
            $result = app('db')->select("SELECT * FROM transaction_details");
            return response()->json($result, 200);
        }
        catch (QueryException $e)
        {
            return response()->json(['error' => $e], 500);
        }
        
    }
}