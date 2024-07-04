<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class DepotController extends Controller
{
    function getDEPO(request $req){

        return DB::select("SELECT     DEPO, LIB  FROM        T017 WHERE     (DOS = ".$req->DOS.") ");
    }
}
