<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class MOVController extends Controller
{
    function get_ligne(Request $req){

        $PICOD= null ;


        if($req->PICOD == "2"  )
        {
            $PICOD ="AND MOUV.CDNO = $req->ENT_PINO AND MOUV.PREFCDNO = '".$req->ENT_PREFPINO."' ";
        }

        if($req->PICOD == "1"  )
        {
            $PICOD ="AND MOUV.DVNO = $req->ENT_PINO AND MOUV.PREFDVNO = '".$req->ENT_PREFPINO."' ";
        }

        if($req->PICOD == "3"  )
        {
            $PICOD ="AND MOUV.BLNO = $req->ENT_PINO AND MOUV.PREFBLNO = '".$req->ENT_PREFPINO."' ";
        }

        if($req->PICOD == "4"  )
        {
            $PICOD ="AND MOUV.FANO = $req->ENT_PINO AND MOUV.PREFFANO = '".$req->ENT_PREFPINO."' ";
        }


        return DB::select("select REF,DES,CDNO,PREFCDNO,CDDT,CDLG,CDQTE,MONT,OP,DEPO,TACOD,VENUN,REFUN from MOUV where MOUV.DOS=".$req->DOS." ".$PICOD." ");
    }
}
