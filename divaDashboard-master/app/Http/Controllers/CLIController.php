<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class CLIController extends Controller
{
    function get_Tiers(){
        return DB::select("select TIERS from CLI ");
    }
}
