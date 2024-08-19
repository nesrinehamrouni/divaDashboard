<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ReglementController extends Controller
{
    public function index()
    {
        $reglements = DB::table('ENT')
            ->select('TIERS', 'PINO', 'HTMT')
            ->get();

        return response()->json($reglements);
    }
}