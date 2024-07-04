<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class ChiffreAffaireController extends Controller
{
    function list(request $req){

        return DB::select("SELECT     CLI.TIERS, CLI.NOM, ENT.TTCMT, ENT.PIDT, MOUV.PUB, MOUV.REM_0001, MOUV.MONT, MOUV.TVAART, CLI.TPFT, ART.TPFR_0001, { fn CONCAT(MOUV.PREFFANO, CONVERT(VARCHAR, MOUV.FANO)) } AS N_FACT, CASE WHEN CLI.TPFT = 1 AND 
        TPFR_0001 = 1 THEN 1 ELSE 0 END AS FODEC, MOUV.FAQTE, CLI.CATCLICOD, derivedtbl_1.TTC_SUM
FROM        (SELECT     DOS, SUM(TTCMT) AS TTC_SUM
         FROM        (SELECT     ENT_1.TTCMT, { fn CONCAT(MOUV_1.PREFFANO, CONVERT(VARCHAR, MOUV_1.FANO)) } AS N_FACT, ART_1.DOS
                            FROM        CLI AS CLI_1 RIGHT OUTER JOIN
                                              MOUV AS MOUV_1 ON CLI_1.TIERS = MOUV_1.TIERS AND CLI_1.DOS = MOUV_1.DOS LEFT OUTER JOIN
                                              ENT AS ENT_1 ON MOUV_1.PREFFANO = ENT_1.PREFPINO AND MOUV_1.FANO = ENT_1.PINO AND MOUV_1.DOS = ENT_1.DOS LEFT OUTER JOIN
                                              ART AS ART_1 ON MOUV_1.REF = ART_1.REF
                            WHERE     (ART_1.DOS = ".$req->DOS.") AND (MOUV_1.TICOD = 'C') AND (MOUV_1.PICOD = 4) AND (CLI_1.TIERSR3 IN ($req->payeur)) AND (ENT_1.PIDT BETWEEN $req->date_debut AND $req->date_fin) AND (CLI_1.CATCLICOD = '2')
                            GROUP BY ENT_1.TTCMT, { fn CONCAT(MOUV_1.PREFFANO, CONVERT(VARCHAR, MOUV_1.FANO)) }, ART_1.DOS) AS derivedtbl_1_1
         GROUP BY DOS) AS derivedtbl_1 INNER JOIN
        ENT ON derivedtbl_1.DOS = ENT.DOS RIGHT OUTER JOIN
        CLI RIGHT OUTER JOIN
        MOUV ON CLI.TIERS = MOUV.TIERS AND CLI.DOS = MOUV.DOS ON ENT.PREFPINO = MOUV.PREFFANO AND ENT.PINO = MOUV.FANO AND ENT.DOS = MOUV.DOS LEFT OUTER JOIN
        ART ON MOUV.REF = ART.REF
WHERE     (MOUV.TICOD = 'C') AND (MOUV.PICOD = 4) AND (ART.DOS = ".$req->DOS.") AND (CLI.TIERSR3 IN ($req->payeur)) AND (ENT.PIDT BETWEEN $req->date_debut AND $req->date_fin) AND (CLI.CATCLICOD = '2')");

        
    }

    function get_payeur(){
        return DB::select("SELECT DISTINCT dbo.CLI.TIERSR3, CLI_1.NOM
        FROM     dbo.CLI LEFT OUTER JOIN
                          dbo.CLI AS CLI_1 ON dbo.CLI.TIERSR3 = CLI_1.TIERS AND dbo.CLI.DOS = CLI_1.DOS
        WHERE  (dbo.CLI.TIERSR3 <> '') AND (dbo.CLI.CATCLICOD = '2')");
    }

    function CLI_MONT_total(request $req){

        return DB::select("SELECT     CLI.TIERS, CLI.NOM, SUM(MOUV.MONT) AS MONTT, derivedtbl_1.TTC_SUM
        FROM        (SELECT     DOS, SUM(TTCMT) AS TTC_SUM
                           FROM        (SELECT     ENT_1.TTCMT, { fn CONCAT(MOUV_1.PREFFANO, CONVERT(VARCHAR, MOUV_1.FANO)) } AS N_FACT, ART_1.DOS
                                              FROM        CLI AS CLI_1 RIGHT OUTER JOIN
                                                                MOUV AS MOUV_1 ON CLI_1.TIERS = MOUV_1.TIERS AND CLI_1.DOS = MOUV_1.DOS LEFT OUTER JOIN
                                                                ENT AS ENT_1 ON MOUV_1.PREFFANO = ENT_1.PREFPINO AND MOUV_1.FANO = ENT_1.PINO AND MOUV_1.DOS = ENT_1.DOS LEFT OUTER JOIN
                                                                ART AS ART_1 ON MOUV_1.REF = ART_1.REF
                                              WHERE     (ART_1.DOS = '1') AND (MOUV_1.TICOD = 'C') AND (MOUV_1.PICOD = 4) AND (CLI_1.TIERSR3 IN ('$req->payeur')) AND (ENT_1.PIDT BETWEEN '$req->date_debut' AND '$req->date_fin') AND (CLI_1.CATCLICOD = '2')
                                              GROUP BY ENT_1.TTCMT, { fn CONCAT(MOUV_1.PREFFANO, CONVERT(VARCHAR, MOUV_1.FANO)) }, ART_1.DOS) AS derivedtbl_1_1
                           GROUP BY DOS) AS derivedtbl_1 INNER JOIN
                          ENT ON derivedtbl_1.DOS = ENT.DOS RIGHT OUTER JOIN
                          CLI RIGHT OUTER JOIN
                          MOUV ON CLI.TIERS = MOUV.TIERS AND CLI.DOS = MOUV.DOS ON ENT.PREFPINO = MOUV.PREFFANO AND ENT.PINO = MOUV.FANO AND ENT.DOS = MOUV.DOS LEFT OUTER JOIN
                          ART ON MOUV.REF = ART.REF
        WHERE     (MOUV.TICOD = 'C') AND (MOUV.PICOD = 4) AND (ART.DOS = '1') AND (CLI.TIERSR3 IN ('$req->payeur')) AND (CLI.CATCLICOD = '2') AND (ENT.PIDT BETWEEN '$req->date_debut' AND '$req->date_fin')
        GROUP BY CLI.TIERS, CLI.NOM, derivedtbl_1.TTC_SUM");
    }


    function list_CA_Detail(request $req){

        return DB::select("SELECT     CLI.TIERS, CLI.NOM, { fn CONCAT(MOUV.PREFFANO, CONVERT(VARCHAR, MOUV.FANO)) } AS N_FACT, ENT.PIDT, SUM(MOUV.PUB * MOUV.FAQTE) AS CA_Brut, SUM(CASE WHEN CLI.TPFT = 1 AND TPFR_0001 = 1 THEN (MOUV.PUB * MOUV.FAQTE * 1.01) 
        ELSE (MOUV.PUB * MOUV.FAQTE) END) AS CAB_FOD, SUM(CASE WHEN CLI.TPFT = 1 AND TPFR_0001 = 1 THEN (MOUV.PUB * MOUV.FAQTE * 1.01) * MOUV.REM_0001 / 100 ELSE (MOUV.PUB * MOUV.FAQTE) * MOUV.REM_0001 / 100 END) AS MT_Rem, 
        SUM(CASE WHEN CLI.TPFT = 1 AND TPFR_0001 = 1 THEN MONT * 1.01 ELSE MONT END) AS NET_FOD, ENT.TTCMT AS [CA_TTC], SUM(MOUV.REM_0001) AS SREM_0001, MOUV.TVAART, SUM(MOUV.FAQTE) AS SFAQTE, derivedtbl_1.TTC_SUM
FROM        (SELECT     DOS, SUM(TTCMT) AS TTC_SUM
         FROM        (SELECT     ENT_1.TTCMT, { fn CONCAT(MOUV_1.PREFFANO, CONVERT(VARCHAR, MOUV_1.FANO)) } AS N_FACT, ART_1.DOS
                            FROM        CLI AS CLI_1 RIGHT OUTER JOIN
                                              MOUV AS MOUV_1 ON CLI_1.TIERS = MOUV_1.TIERS AND CLI_1.DOS = MOUV_1.DOS LEFT OUTER JOIN
                                              ENT AS ENT_1 ON MOUV_1.PREFFANO = ENT_1.PREFPINO AND MOUV_1.FANO = ENT_1.PINO AND MOUV_1.DOS = ENT_1.DOS LEFT OUTER JOIN
                                              ART AS ART_1 ON MOUV_1.REF = ART_1.REF
                            WHERE     (ART_1.DOS = '".$req->DOS."') AND (MOUV_1.TICOD = 'C') AND (MOUV_1.PICOD = 4) AND (CLI_1.TIERSR3 IN ('$req->payeur')) AND (ENT_1.PIDT BETWEEN '$req->date_debut' AND '$req->date_fin') AND (CLI_1.CATCLICOD = '2')
                            GROUP BY ENT_1.TTCMT, { fn CONCAT(MOUV_1.PREFFANO, CONVERT(VARCHAR, MOUV_1.FANO)) }, ART_1.DOS) AS derivedtbl_1_1
         GROUP BY DOS) AS derivedtbl_1 INNER JOIN
        ENT ON derivedtbl_1.DOS = ENT.DOS RIGHT OUTER JOIN
        CLI RIGHT OUTER JOIN
        MOUV ON CLI.TIERS = MOUV.TIERS AND CLI.DOS = MOUV.DOS ON ENT.PREFPINO = MOUV.PREFFANO AND ENT.PINO = MOUV.FANO AND ENT.DOS = MOUV.DOS LEFT OUTER JOIN
        ART ON MOUV.REF = ART.REF
WHERE     (ART.DOS = ".$req->DOS.") AND (MOUV.TICOD = 'C') AND (MOUV.PICOD = 4) AND (CLI.TIERSR3 IN ('$req->payeur'))
GROUP BY CLI.TIERS, CLI.NOM, { fn CONCAT(MOUV.PREFFANO, CONVERT(VARCHAR, MOUV.FANO)) }, ENT.PIDT, ENT.TTCMT, MOUV.TVAART, CLI.TPFT, ART.TPFR_0001, CLI.CATCLICOD, derivedtbl_1.TTC_SUM
HAVING     (CLI.CATCLICOD = '2') AND (ENT.PIDT BETWEEN '$req->date_debut' AND '$req->date_fin')");
    }


    function getCA_ShowRoom(request $req){
        return DB::select("SELECT     CLI.TIERS, CLI.NOM, SUM(MOUV.MONT) AS MONT,  ISNULL(derivedtbl_1.Sum_TTC,0)
        FROM        (SELECT     ENT_1.DOS, SUM(ENT_1.TTCMT) AS Sum_TTC, CLI_1.TIERS
                           FROM        ENT AS ENT_1 LEFT OUTER JOIN
                                             CLI AS CLI_1 ON ENT_1.DOS = CLI_1.DOS AND ENT_1.TIERS = CLI_1.TIERS
                           WHERE     (ENT_1.PIDT BETWEEN '$req->date_debut' AND '$req->date_fin') AND (CLI_1.CATCLICOD = '1') 
                           GROUP BY ENT_1.DOS, CLI_1.TIERS
                           HAVING     (ENT_1.DOS = ".$req->DOS.")) AS derivedtbl_1 INNER JOIN
                          CLI ON derivedtbl_1.DOS = CLI.DOS AND derivedtbl_1.TIERS = CLI.TIERS RIGHT OUTER JOIN
                          MOUV LEFT OUTER JOIN
                          ART ON MOUV.DOS = ART.DOS AND MOUV.REF = ART.REF LEFT OUTER JOIN
                          ENT ON MOUV.DOS = ENT.DOS AND MOUV.PREFFANO = ENT.PREFPINO AND MOUV.FANO = ENT.PINO ON CLI.DOS = MOUV.DOS AND CLI.TIERS = MOUV.TIERS
        WHERE     (MOUV.TICOD = 'C') AND (MOUV.PICOD = 4) AND (MOUV.DOS = ".$req->DOS.") AND (MOUV.FAQTE > 0) AND (MOUV.FADT BETWEEN '$req->date_debut' AND '$req->date_fin') AND (MOUV.MONT > 0)
        GROUP BY CLI.TIERS, CLI.NOM, derivedtbl_1.Sum_TTC");
    }
    function getCA_ShowRoom_detail(request $req){
        return DB::select("SELECT     CLI.TIERS, CLI.NOM, { fn CONCAT(MOUV.PREFFANO, CONVERT(VARCHAR, MOUV.FANO)) } AS NUM_PIECE, MOUV.FADT, SUM(MOUV.MONT) AS MONT, derivedtbl_1.Sum_TTC
        FROM        (SELECT     ENT_1.DOS, SUM(ENT_1.TTCMT) AS Sum_TTC, CLI_1.TIERS
                           FROM        ENT AS ENT_1 LEFT OUTER JOIN
                                             CLI AS CLI_1 ON ENT_1.DOS = CLI_1.DOS AND ENT_1.TIERS = CLI_1.TIERS
                           WHERE     (ENT_1.PIDT BETWEEN '$req->date_debut' AND '$req->date_fin')
                           GROUP BY ENT_1.DOS, CLI_1.TIERS
                           HAVING     (ENT_1.DOS = '1')) AS derivedtbl_1 INNER JOIN
                          CLI ON derivedtbl_1.DOS = CLI.DOS AND derivedtbl_1.TIERS = CLI.TIERS RIGHT OUTER JOIN
                          MOUV LEFT OUTER JOIN
                          ART ON MOUV.DOS = ART.DOS AND MOUV.REF = ART.REF LEFT OUTER JOIN
                          ENT ON MOUV.DOS = ENT.DOS AND MOUV.PREFFANO = ENT.PREFPINO AND MOUV.FANO = ENT.PINO ON CLI.DOS = MOUV.DOS AND CLI.TIERS = MOUV.TIERS
        WHERE     (MOUV.TICOD = 'C') AND (MOUV.PICOD = 4) AND (MOUV.DOS = '".$req->DOS."')
        GROUP BY CLI.TIERS, CLI.NOM, { fn CONCAT(MOUV.PREFFANO, CONVERT(VARCHAR, MOUV.FANO)) }, MOUV.FADT, derivedtbl_1.Sum_TTC
        HAVING     (MOUV.FADT BETWEEN '$req->date_debut' AND '$req->date_fin') AND (CLI.TIERS = '$req->ShowRoom')");
    }
}

# AND (CLI.TIERS IS NOT NULL)
