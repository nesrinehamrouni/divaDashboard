<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class PieceController extends Controller
{
    function get_PieceCLI(request $req){
        $ETB = null ;
        $Etat = null ;
        $Tiers = null ;
        $PICOD = null ;
        $date = null ;
        $PINO = null ;
    
    if($req->ETB != "" )
        {
            $ETB ="AND ENT.ETB = ".$req->ETB."";
        }

        if($req->CE4 != "" )
        {
            $Etat ="AND ENT.CE4 = ".$req->CE4."";
        }
        if($req->Tiers != "" )
        {
            $Tiers ="AND ENT.TIERS = '".$req->Tiers."'";
        }
        if($req->PICOD != "" )
        {
            $PICOD ="AND ENT.PICOD = ".$req->PICOD."";
        }
        if($req->date_debut != "" && $req->date_fin != "" )
        {
            $date ="AND (ENT.PIDT BETWEEN '$req->date_debut' AND '$req->date_fin')";
        }

        if($req->PINO1 != "" && $req->PINO2 != "" )
        {
            $PINO ="AND (ENT.PINO BETWEEN '$req->PINO1' AND '$req->PINO2')";
        }

        return DB::select("SELECT     TOP (500) ENT.ENT_ID, ENT.CE4, ENT.DOS, ENT.TICOD, ENT.PICOD, ENT.TIERS, ENT.PREFPINO, ENT.PINO, ENT.PIDT, ENT.ETB, ENT.STATUS, ENT.DEV, ENT.OP, ENT.REPR_0001, ENT.DEPO, ENT.PIREF, ENT.PINOTIERS, ENT.REMCOD, ENT.TPFT, ENT.HTMT, 
        ENT.TTCMT, ENT.HTPDTMT, ENT.PIEDNO_0001, ENT.PIRELCOD, ENT.RELCOD, ENT.TRCOD, ENT.REM_0001, ENT.CATPICOD, CLI.NOM
FROM        ENT LEFT OUTER JOIN
        CLI ON ENT.TIERS = CLI.TIERS
WHERE     (ENT.DOS = ".$req->DOS.") AND (ENT.TICOD = 'C') ".$ETB." ".$Etat." ".$Tiers." ".$PICOD." ".$date." ".$PINO."
ORDER BY ENT.PIDT DESC");
    }



    function get_PieceFOU(request $req){
        $ETB = null ;
        $Etat = null ;
        $Tiers = null ;
        $PICOD = null ;
        $date = null ;
        $PINO = null ;
    
    if($req->ETB != "" )
        {
            $ETB ="AND ENT.ETB = ".$req->ETB."";
        }

        if($req->CE4 != "" )
        {
            $Etat ="AND ENT.CE4 = ".$req->CE4."";
        }
        if($req->Tiers != "" )
        {
            $Tiers ="AND ENT.TIERS = '".$req->Tiers."'";
        }
        if($req->PICOD != "" )
        {
            $PICOD ="AND ENT.PICOD = ".$req->PICOD."";
        }
        if($req->date_debut != "" && $req->date_fin != "" )
        {
            $date ="AND (ENT.PIDT BETWEEN '$req->date_debut' AND '$req->date_fin')";
        }

        if($req->PINO1 != "" && $req->PINO2 != "" )
        {
            $PINO ="AND (ENT.PINO BETWEEN '$req->PINO1' AND '$req->PINO2')";
        }

        return DB::select("SELECT     TOP (500) ENT.ENT_ID, ENT.CE4, ENT.DOS, ENT.TICOD, ENT.PICOD, ENT.TIERS, ENT.PREFPINO, ENT.PINO, ENT.PIDT, ENT.ETB, ENT.STATUS, ENT.DEV, ENT.OP, ENT.REPR_0001, ENT.DEPO, ENT.PIREF, ENT.PINOTIERS, ENT.REMCOD, ENT.TPFT, ENT.HTMT, 
        ENT.TTCMT, ENT.HTPDTMT, ENT.PIEDNO_0001, ENT.PIRELCOD, ENT.RELCOD, ENT.TRCOD, ENT.REM_0001, ENT.CATPICOD, CLI.NOM
FROM        ENT LEFT OUTER JOIN
        CLI ON ENT.TIERS = CLI.TIERS
WHERE     (ENT.DOS = ".$req->DOS.") AND (ENT.TICOD = 'F') ".$ETB." ".$Etat." ".$Tiers." ".$PICOD." ".$date." ".$PINO."
ORDER BY ENT.PIDT DESC");
    }




    
}
