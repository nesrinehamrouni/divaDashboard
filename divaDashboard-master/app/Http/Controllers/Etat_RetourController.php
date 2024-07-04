<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class Etat_RetourController extends Controller
{
    function getRetour_ART(request $req){

        return DB::select("SELECT     MOUV.TIERS, CASE MOUV.TICOD WHEN 'I' THEN CONCAT(dbo.MOUV.PREFCDNO, CONVERT(VARCHAR, dbo.MOUV.CDNO)) ELSE CONCAT(dbo.MOUV.PREFBLNO, CONVERT(VARCHAR, dbo.MOUV.BLNO)) END AS NUM_PIECE, 
        CASE MOUV.TICOD WHEN 'I' THEN dbo.MOUV.CDDT ELSE dbo.MOUV.BLDT END AS DT, CASE MOUV.TICOD WHEN 'I' THEN dbo.TIA.NOM ELSE dbo.CLI.NOM END AS NOM, MOUV.DES, { fn CONCAT(MOUV.PREFFANO, CONVERT(VARCHAR, MOUV.FANO)) 
        } AS NUM_FACT, CASE dbo.MOUV.BLQTE WHEN 0 THEN dbo.MOUV.CDQTE ELSE dbo.MOUV.BLQTE END AS QTE, MOUV.TICOD, MOUV.OP, MOUV.BLSLG, MOUV.FADT, MOUV.UMOTIF_RETOUR, derivedtbl_1.RTRQTE, MOUV.U_DESC, TIA.NOM AS Expr1, 
        MOUV.REF
FROM        (SELECT     SUM(CASE WHEN MOUV_1.BLQTE = 0 THEN MOUV_1.CDQTE ELSE MOUV_1.BLQTE END) AS RTRQTE, MOUV_1.DOS
         FROM        MOUV AS MOUV_1 LEFT OUTER JOIN
                           CLI AS CLI_1 ON MOUV_1.TIERS = CLI_1.TIERS AND MOUV_1.DOS = CLI_1.DOS
         WHERE     (MOUV_1.PICOD = 3 OR
                           MOUV_1.PICOD = 4) AND (MOUV_1.OP LIKE 'D%') AND (MOUV_1.TICOD = 'C') AND (MOUV_1.BLSLG = 0) AND (MOUV_1.DOS = '".$req->DOS."') AND (MOUV_1.BLDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') OR
                           (MOUV_1.PICOD = 2) AND (MOUV_1.TICOD = 'I') AND (MOUV_1.DOS = '".$req->DOS."') AND (MOUV_1.CDSLG = 0) AND (MOUV_1.PREFCDNO = 'FREM' OR
                           MOUV_1.PREFCDNO = 'RBLM') AND (MOUV_1.CDDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."')
         GROUP BY MOUV_1.DOS) AS derivedtbl_1 RIGHT OUTER JOIN
        MOUV LEFT OUTER JOIN
        TIA ON MOUV.DOS = TIA.DOS AND MOUV.TIERS = TIA.TIERS ON derivedtbl_1.DOS = MOUV.DOS LEFT OUTER JOIN
        CLI ON MOUV.TIERS = CLI.TIERS AND MOUV.DOS = CLI.DOS
WHERE     (MOUV.TICOD = 'C') AND (MOUV.PICOD = 3 OR
        MOUV.PICOD = 4) AND (MOUV.OP LIKE 'D%') AND (MOUV.BLSLG = 0) AND (MOUV.DOS = '".$req->DOS."') AND (MOUV.BLDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') OR
        (MOUV.TICOD = 'I') AND (MOUV.PICOD = 2) AND (MOUV.DOS = '".$req->DOS."') AND (MOUV.CDSLG = 0) AND (MOUV.PREFCDNO = 'FREM' OR
        MOUV.PREFCDNO = 'RBLM') AND (MOUV.CDDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."')");
    }


    function getRetour_ART_Entete(request $req){

        return DB::select("SELECT     TOP (10) MOUV.DES, CASE dbo.MOUV.BLQTE WHEN 0 THEN SUM(dbo.MOUV.CDQTE) ELSE SUM(dbo.MOUV.BLQTE) END AS QTE, MOUV.REF
        FROM        (SELECT     SUM(CASE WHEN MOUV_1.BLQTE = 0 THEN MOUV_1.CDQTE ELSE MOUV_1.BLQTE END) AS RTRQTE, MOUV_1.DOS
                           FROM        MOUV AS MOUV_1 LEFT OUTER JOIN
                                             CLI AS CLI_1 ON MOUV_1.TIERS = CLI_1.TIERS AND MOUV_1.DOS = CLI_1.DOS
                           WHERE     (MOUV_1.PICOD = 3 OR
                                             MOUV_1.PICOD = 4) AND (MOUV_1.OP LIKE 'D%') AND (MOUV_1.TICOD = 'C') AND (MOUV_1.BLSLG = 0) AND (MOUV_1.DOS = '".$req->DOS."') AND (MOUV_1.BLDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') OR
                                             (MOUV_1.PICOD = 2) AND (MOUV_1.TICOD = 'I') AND (MOUV_1.DOS = '".$req->DOS."') AND (MOUV_1.CDSLG = 0) AND (MOUV_1.PREFCDNO = 'FREM' OR
                                             MOUV_1.PREFCDNO = 'RBLM') AND (MOUV_1.CDDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."')
                           GROUP BY MOUV_1.DOS) AS derivedtbl_1 RIGHT OUTER JOIN
                          MOUV LEFT OUTER JOIN
                          TIA ON MOUV.DOS = TIA.DOS AND MOUV.TIERS = TIA.TIERS ON derivedtbl_1.DOS = MOUV.DOS LEFT OUTER JOIN
                          CLI ON MOUV.TIERS = CLI.TIERS AND MOUV.DOS = CLI.DOS
        WHERE     (MOUV.PICOD = 3 OR
                          MOUV.PICOD = 4) AND (MOUV.DOS = '".$req->DOS."') AND (MOUV.BLDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') AND (MOUV.TICOD = 'C') AND (MOUV.OP LIKE 'D%') AND (MOUV.BLSLG = 0) OR
                          (MOUV.PICOD = 2) AND (MOUV.DOS = '".$req->DOS."') AND (MOUV.CDSLG = 0) AND (MOUV.PREFCDNO = 'FREM' OR
                          MOUV.PREFCDNO = 'RBLM') AND (MOUV.CDDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') AND (MOUV.TICOD = 'I')
        GROUP BY MOUV.DES, MOUV.REF, MOUV.BLQTE
        ORDER BY QTE DESC ");
    }

    function getRetour_ART_Ligne(request $req){

        return DB::select("SELECT     MOUV.TIERS, CASE MOUV.TICOD WHEN 'I' THEN CONCAT(dbo.MOUV.PREFCDNO, CONVERT(VARCHAR, dbo.MOUV.CDNO)) ELSE CONCAT(dbo.MOUV.PREFBLNO, CONVERT(VARCHAR, dbo.MOUV.BLNO)) END AS NUM_PIECE, 
        CASE MOUV.TICOD WHEN 'I' THEN dbo.MOUV.CDDT ELSE dbo.MOUV.BLDT END AS DT, CASE MOUV.TICOD WHEN 'I' THEN dbo.TIA.NOM ELSE dbo.CLI.NOM END AS NOM,  { fn CONCAT(MOUV.PREFFANO, CONVERT(VARCHAR, MOUV.FANO)) 
        } AS NUM_FACT, CASE dbo.MOUV.BLQTE WHEN 0 THEN dbo.MOUV.CDQTE ELSE dbo.MOUV.BLQTE END AS QTE, MOUV.TICOD, MOUV.OP, MOUV.BLSLG, MOUV.FADT, MOUV.UMOTIF_RETOUR, derivedtbl_1.RTRQTE, MOUV.U_DESC, MOUV.REF
FROM        (SELECT     SUM(CASE WHEN MOUV_1.BLQTE = 0 THEN MOUV_1.CDQTE ELSE MOUV_1.BLQTE END) AS RTRQTE, MOUV_1.DOS
         FROM        MOUV AS MOUV_1 LEFT OUTER JOIN
                           CLI AS CLI_1 ON MOUV_1.TIERS = CLI_1.TIERS AND MOUV_1.DOS = CLI_1.DOS
         WHERE     (MOUV_1.PICOD = 3 OR
                           MOUV_1.PICOD = 4) AND (MOUV_1.OP LIKE 'D%') AND (MOUV_1.TICOD = 'C') AND (MOUV_1.BLSLG = 0) AND (MOUV_1.DOS = '".$req->DOS."') AND (MOUV_1.BLDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') OR
                           (MOUV_1.PICOD = 2) AND (MOUV_1.TICOD = 'I') AND (MOUV_1.DOS = '".$req->DOS."') AND (MOUV_1.CDSLG = 0) AND (MOUV_1.PREFCDNO = 'FREM' OR
                           MOUV_1.PREFCDNO = 'RBLM') AND (MOUV_1.CDDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."')
         GROUP BY MOUV_1.DOS) AS derivedtbl_1 RIGHT OUTER JOIN
        MOUV LEFT OUTER JOIN
        TIA ON MOUV.DOS = TIA.DOS AND MOUV.TIERS = TIA.TIERS ON derivedtbl_1.DOS = MOUV.DOS LEFT OUTER JOIN
        CLI ON MOUV.TIERS = CLI.TIERS AND MOUV.DOS = CLI.DOS
WHERE     (MOUV.TICOD = 'C') AND (MOUV.PICOD = 3 OR
        MOUV.PICOD = 4) AND (MOUV.OP LIKE 'D%') AND (MOUV.BLSLG = 0) AND (MOUV.DOS = '".$req->DOS."') AND (MOUV.BLDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') AND (MOUV.REF = '".$req->article."') OR
        (MOUV.TICOD = 'I') AND (MOUV.PICOD = 2) AND (MOUV.DOS = '".$req->DOS."') AND (MOUV.CDSLG = 0) AND (MOUV.PREFCDNO = 'FREM' OR
        MOUV.PREFCDNO = 'RBLM') AND (MOUV.CDDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') AND (MOUV.REF = '".$req->article."') ");
    }



    function getRetour_REP_Entete(request $req){

        return DB::select("SELECT  TOP(10)   SUM(CASE dbo.MOUV.BLQTE WHEN 0 THEN dbo.MOUV.CDQTE ELSE dbo.MOUV.BLQTE END) AS QTE, VRP.NOM AS DES,VRP.TIERS AS REF
        FROM        (SELECT     SUM(CASE WHEN MOUV_1.BLQTE = 0 THEN MOUV_1.CDQTE ELSE MOUV_1.BLQTE END) AS RTRQTE, MOUV_1.DOS
                           FROM        MOUV AS MOUV_1 LEFT OUTER JOIN
                                             CLI AS CLI_1 ON MOUV_1.TIERS = CLI_1.TIERS AND MOUV_1.DOS = CLI_1.DOS
                           WHERE     (MOUV_1.PICOD = 3 OR
                                             MOUV_1.PICOD = 4) AND (MOUV_1.OP LIKE 'D%') AND (MOUV_1.TICOD = 'C') AND (MOUV_1.BLSLG = 0) AND (MOUV_1.DOS = '".$req->DOS."') AND (MOUV_1.BLDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') OR
                                             (MOUV_1.PICOD = 2) AND (MOUV_1.TICOD = 'I') AND (MOUV_1.DOS = '".$req->DOS."') AND (MOUV_1.CDSLG = 0) AND (MOUV_1.PREFCDNO = 'FREM' OR
                                             MOUV_1.PREFCDNO = 'RBLM') AND (MOUV_1.CDDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."')
                           GROUP BY MOUV_1.DOS) AS derivedtbl_1 RIGHT OUTER JOIN
                          MOUV LEFT OUTER JOIN
                          TIA ON MOUV.DOS = TIA.DOS AND MOUV.TIERS = TIA.TIERS ON derivedtbl_1.DOS = MOUV.DOS LEFT OUTER JOIN
                          VRP INNER JOIN
                          CLI ON VRP.TIERS = CLI.REPR_0001 AND VRP.DOS = CLI.DOS ON MOUV.TIERS = CLI.TIERS AND MOUV.DOS = CLI.DOS
        WHERE     (MOUV.PICOD = 3 OR
                          MOUV.PICOD = 4) AND (MOUV.DOS = '".$req->DOS."') AND (MOUV.BLDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') AND (MOUV.TICOD = 'C') AND (MOUV.OP LIKE 'D%') AND (MOUV.BLSLG = 0) OR
                          (MOUV.PICOD = 2) AND (MOUV.DOS = '".$req->DOS."') AND (MOUV.CDSLG = 0) AND (MOUV.PREFCDNO = 'FREM' OR
                          MOUV.PREFCDNO = 'RBLM') AND (MOUV.CDDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') AND (MOUV.TICOD = 'I')
        GROUP BY VRP.NOM, VRP.TIERS ");
    }

    function getRetour_REP_Ligne(request $req){

        return DB::select("SELECT     MOUV.TIERS, CASE MOUV.TICOD WHEN 'I' THEN CONCAT(dbo.MOUV.PREFCDNO, CONVERT(VARCHAR, dbo.MOUV.CDNO)) ELSE CONCAT(dbo.MOUV.PREFBLNO, CONVERT(VARCHAR, dbo.MOUV.BLNO)) END AS NUM_PIECE, 
                  CASE MOUV.TICOD WHEN 'I' THEN dbo.MOUV.CDDT ELSE dbo.MOUV.BLDT END AS DT, CASE MOUV.TICOD WHEN 'I' THEN dbo.TIA.NOM ELSE dbo.CLI.NOM END AS NOM, MOUV.DES, { fn CONCAT(MOUV.PREFFANO, CONVERT(VARCHAR, MOUV.FANO)) 
                  } AS NUM_FACT, CASE dbo.MOUV.BLQTE WHEN 0 THEN dbo.MOUV.CDQTE ELSE dbo.MOUV.BLQTE END AS QTE, MOUV.TICOD, MOUV.OP, MOUV.BLSLG, MOUV.FADT, MOUV.UMOTIF_RETOUR, derivedtbl_1.RTRQTE, VRP.NOM AS Represeantant, MOUV.U_DESC, 
                  VRP.TIERS AS REFREP
FROM        (SELECT     SUM(CASE WHEN MOUV_1.BLQTE = 0 THEN MOUV_1.CDQTE ELSE MOUV_1.BLQTE END) AS RTRQTE, MOUV_1.DOS
                   FROM        MOUV AS MOUV_1 LEFT OUTER JOIN
                                     CLI AS CLI_1 ON MOUV_1.TIERS = CLI_1.TIERS AND MOUV_1.DOS = CLI_1.DOS
                   WHERE     (MOUV_1.PICOD = 3 OR
                                     MOUV_1.PICOD = 4) AND (MOUV_1.OP LIKE 'D%') AND (MOUV_1.TICOD = 'C') AND (MOUV_1.BLSLG = 0) AND (MOUV_1.DOS = '".$req->DOS."') AND (MOUV_1.BLDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') OR
                                     (MOUV_1.PICOD = 2) AND (MOUV_1.TICOD = 'I') AND (MOUV_1.DOS = '".$req->DOS."') AND (MOUV_1.CDSLG = 0) AND (MOUV_1.PREFCDNO = 'FREM' OR
                                     MOUV_1.PREFCDNO = 'RBLM') AND (MOUV_1.CDDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."')
                   GROUP BY MOUV_1.DOS) AS derivedtbl_1 RIGHT OUTER JOIN
                  MOUV LEFT OUTER JOIN
                  TIA ON MOUV.DOS = TIA.DOS AND MOUV.TIERS = TIA.TIERS ON derivedtbl_1.DOS = MOUV.DOS LEFT OUTER JOIN
                  VRP INNER JOIN
                  CLI ON VRP.TIERS = CLI.REPR_0001 AND VRP.DOS = CLI.DOS ON MOUV.TIERS = CLI.TIERS AND MOUV.DOS = CLI.DOS
                  WHERE     (MOUV.PICOD = 3 OR
                  MOUV.PICOD = 4) AND (MOUV.DOS = '".$req->DOS."') AND (MOUV.BLDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') AND (MOUV.TICOD = 'C') AND (MOUV.OP LIKE 'D%') AND (MOUV.BLSLG = 0) AND (VRP.TIERS = '".$req->REP."') OR
                  (MOUV.PICOD = 2) AND (MOUV.DOS = '".$req->DOS."') AND (MOUV.CDSLG = 0) AND (MOUV.PREFCDNO = 'FREM' OR
                  MOUV.PREFCDNO = 'RBLM') AND (MOUV.CDDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."') AND (MOUV.TICOD = 'I')");
    }
}
