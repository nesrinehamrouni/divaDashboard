<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class DOS_ETBController extends Controller
{
    function get_DOS(){

        return DB::select("SELECT  DOS,NOM FROM [SOTUFAB].[dbo].[SOC] ");
    }

    function get_ETB(request $req){

        return DB::select("SELECT     ETB, NOM
        FROM        ETS
        WHERE     (DOS = $req->DOS)");
    }
}
