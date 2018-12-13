<?php

namespace App\Http\Controllers;

use App\User;

class BankController extends Controller
{
    public function test()
    {
        return response()->json(['all' => 2], 200);
    }

    /**
     * Retrieve the number of banks.
     *
     * @return Response
     */
    public function count()
    {
        $dbh = new PDO("postgres://fkujkbucvxqjxj:13221ec17908bc3b474605a583f6a9017266a70068a7f774f32fdebf4c5338a6@ec2-54-75-231-156.eu-west-1.compute.amazonaws.com:5432/d928ssskcmp00m");
        $stmt = $this->pdo->query("SELECT count(*) as numberOfBanks FROM bank");

        //$result = app('db')->select("SELECT count(*) as numberOfBanks FROM bank");
        $result = $stmt->fetch();
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