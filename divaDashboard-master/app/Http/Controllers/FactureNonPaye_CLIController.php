<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class FactureNonPaye_CLIController extends Controller
{
    function getEtatFA_nonPaye_CLI(Request $req){

        return DB::select("SELECT derivedtbl_2.REPR_0001, derivedtbl_2.NOMREP, derivedtbl_2.ETB, derivedtbl_2.TIERS, derivedtbl_2.NOM, derivedtbl_2.FADT, { fn CONCAT(derivedtbl_2.PREFFANO, derivedtbl_2.FANO) } AS NUM_FC, derivedtbl_2.[MT FC], 
        derivedtbl_2.PAYE, derivedtbl_2.RESTE, derivedtbl_2.Controle, derivedtbl_2.ETAB, ISNULL(derivedtbl_3.MTACOMPTE, 0) AS ACOMPTE
FROM     (SELECT TOP (100) PERCENT REPR_0001, NOMREP, ETB, TIERS, NOM, FADT, PREFFANO, CASE WHEN PINOTIERS <> '' THEN PINOTIERS ELSE CONVERT(varchar, FANO) END AS FANO, [MT FC], [MT FC] - MT AS PAYE, MT AS RESTE, 
                          Controle, CASE WHEN ETB = 1 THEN 'MEUBLE' ELSE CASE WHEN ETB = 2 THEN 'MEUBLE' ELSE CASE WHEN PREFFANO IN ('22F', 'F') 
                          THEN 'MEUBLE' ELSE CASE WHEN FANO LIKE '230%' THEN 'MEUBLE' ELSE CASE WHEN PINOTIERS LIKE '%FH%' THEN 'PLAST' ELSE 'MEUBLE' END END END END END AS ETAB
        FROM      (SELECT R2.R2_ID, R2.CE1, R2.CE3, R2.CE5, R2.DOS AS Expr1, R2.ETB, R2.G3CE1, R2.EFF, R2.TRANSAC, R2.TIERS, R2.ETAT, R2.ECHDT, R2.EMIDT, R2.EFFDT, R2.MT, LIENFACTURE.PREFFANO, LIENFACTURE.FANO, 
                                             FACTURE.FADT, FACTURE.MT AS [MT FC], CLI.NOM, CLI.REPR_0001, VRP.NOM AS NOMREP, CLI.ADRCPL1, CLI.ADRCPL2, CLI.RUE, CLI.LOC, CLI.VIL, 
                                             CASE dbo.CLI.FEU WHEN 3 THEN 'Bloqué' WHEN 2 THEN 'A Surveiller' ELSE '' END AS Controle, C8.PINOTIERS
                           FROM      R2C8 LEFT OUTER JOIN
                                             C8 ON R2C8.DOS = C8.DOS AND R2C8.ECRNO = C8.ECRNO AND R2C8.ECRLG = C8.ECRLG RIGHT OUTER JOIN
                                             R2 ON R2C8.EFF = R2.EFF AND R2C8.DOS = R2.DOS LEFT OUTER JOIN
                                             VRP RIGHT OUTER JOIN
                                             CLI ON VRP.TIERS = CLI.REPR_0001 AND VRP.DOS = CLI.DOS ON R2.DOS = CLI.DOS AND R2.TIERS = CLI.TIERS LEFT OUTER JOIN
                                             RA AS ETAT ON ETAT.ETAT = R2.ETAT LEFT OUTER JOIN
                                             R3 AS LIENFACTURE ON LIENFACTURE.R3_ID =
                                                 (SELECT TOP (1) R3_ID
                                                  FROM      R3 AS R3FANO
                                                  WHERE   (CE1 = '3') AND (R2.DOS = DOS) AND (G3CE1 = R2.G3CE1) AND (EFF = R2.EFF) AND (TIERS IS NOT NULL) AND (FANO IS NOT NULL)
                                                  ORDER BY PREFFANO, FANO) LEFT OUTER JOIN
                                             R1 AS FACTURE ON FACTURE.DOS = LIENFACTURE.DOS AND FACTURE.G3CE1 = LIENFACTURE.G3CE1 AND FACTURE.TIERS = LIENFACTURE.TIERS AND FACTURE.PREFPIECE = LIENFACTURE.PREFFANO AND 
                                             FACTURE.PIECE = LIENFACTURE.FANO
                           WHERE   (R2.DOS = ".$req->DOS.") AND (R2.CE1 = '2') AND (R2.CE5 = '1') AND (R2.CE3 = '1' OR
                                             R2.CE3 = '2' OR
                                             R2.CE3 = '3') AND (R2.G3CE1 = 3) AND (R2.ETAT LIKE '%10')) AS derivedtbl_1
        UNION ALL
        SELECT ENT.REPR_0001, VRP_1.NOM, ENT.ETB, ENT.TIERS, CLI_1.NOM AS CLI, ENT.PIDT, ENT.PREFPINO, CONVERT(varchar, ENT.PINO) AS FANO, 
                          CASE WHEN dbo.ENT.OP LIKE 'D%' THEN - dbo.ENT.TTCMT ELSE dbo.ENT.TTCMT END AS TTCMT, 0 AS PAYE, CASE WHEN dbo.ENT.OP LIKE 'D%' THEN - dbo.ENT.TTCMT ELSE dbo.ENT.TTCMT END AS RESTE, 
                          CASE CLI_1.FEU WHEN 3 THEN 'Bloqué' WHEN 2 THEN 'A Surveiller' ELSE '' END AS Controle, CASE WHEN dbo.ENT.ETB = 2 THEN 'PLAST' ELSE 'MEUBLE' END AS ETAB
        FROM     ENT LEFT OUTER JOIN
                          CLI AS CLI_1 ON ENT.TIERS = CLI_1.TIERS AND ENT.DOS = CLI_1.DOS LEFT OUTER JOIN
                          VRP AS VRP_1 ON ENT.REPR_0001 = VRP_1.TIERS AND ENT.DOS = VRP_1.DOS
        WHERE  (ENT.PICOD = 4) AND (ENT.TICOD = 'C') AND (ENT.DOS = '".$req->DOS."') AND (ENT.CE2 = '1')) AS derivedtbl_2 LEFT OUTER JOIN
            (SELECT derivedtbl_1_1.TIERS, CLI_2.NOM, SUM(derivedtbl_1_1.MTACOMPTE) AS MTACOMPTE, CLI_2.REPR_0001, VRP_2.NOM AS NOMREP, 
                               CASE CLI_2.FEU WHEN 3 THEN 'Bloqué' WHEN 2 THEN 'A Surveiller' ELSE '' END AS Controle, CASE WHEN derivedtbl_1_1.USIM_ETB = 2 THEN 'PLAST' ELSE 'MEUBLE' END AS ETAB
             FROM      VRP AS VRP_2 RIGHT OUTER JOIN
                               CLI AS CLI_2 ON VRP_2.TIERS = CLI_2.REPR_0001 AND VRP_2.DOS = CLI_2.DOS RIGHT OUTER JOIN
                                   (SELECT R2_1.R2_ID, R2_1.CE1, R2_1.CE3, R2_1.CE5, R2_1.DOS, R2_1.ETB, R2_1.G3CE1, R2_1.EFF, R2_1.TRANSAC, R2_1.TIERS, R2_1.ETAT, R2_1.ECHDT, R2_1.EMIDT, R2_1.EFFDT, - R2_1.MT AS MTACOMPTE, 
                                                      R2_1.USIM_ETB
                                    FROM      R2 AS R2_1 LEFT OUTER JOIN
                                                      RA AS ETAT ON ETAT.ETAT = R2_1.ETAT
                                    WHERE   (R2_1.DOS = ".$req->DOS.") AND (R2_1.CE1 = '2') AND (R2_1.CE5 = '1') AND (R2_1.CE3 = '1' OR
                                                      R2_1.CE3 = '2' OR
                                                      R2_1.CE3 = '3') AND (R2_1.G3CE1 = 3) AND (R2_1.ETAT = 'WAR') AND (R2_1.EFFDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."')) AS derivedtbl_1_1 ON CLI_2.TIERS = derivedtbl_1_1.TIERS AND 
                               CLI_2.DOS = derivedtbl_1_1.DOS
             GROUP BY derivedtbl_1_1.TIERS, CLI_2.NOM, CLI_2.REPR_0001, VRP_2.NOM, CLI_2.FEU, derivedtbl_1_1.USIM_ETB) AS derivedtbl_3 ON derivedtbl_2.TIERS = derivedtbl_3.TIERS AND derivedtbl_2.ETAB = derivedtbl_3.ETAB
WHERE  (derivedtbl_2.TIERS IN ('".$req->client."')) AND (derivedtbl_2.FADT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."')");
    }



   function getTotal(request $req){

        return DB::select("SELECT     derivedtbl_2.NOMREP, derivedtbl_2.TIERS, derivedtbl_2.NOM, SUM(derivedtbl_2.[MT FC]) AS MTT, SUM(derivedtbl_2.PAYE) AS PAYET, SUM(derivedtbl_2.RESTE) AS RESTET, ISNULL(derivedtbl_3.MTACOMPTE, 0) AS ACOMPTE
        FROM        (SELECT     TOP (100) PERCENT REPR_0001, NOMREP, ETB, TIERS, NOM, FADT, PREFFANO, CASE WHEN PINOTIERS <> '' THEN PINOTIERS ELSE CONVERT(varchar, FANO) END AS FANO, [MT FC], [MT FC] - MT AS PAYE, MT AS RESTE, Controle, 
                                             CASE WHEN ETB = 1 THEN 'MEUBLE' ELSE CASE WHEN ETB = 2 THEN 'MEUBLE' ELSE CASE WHEN PREFFANO IN ('22F', 'F') 
                                             THEN 'MEUBLE' ELSE CASE WHEN FANO LIKE '230%' THEN 'MEUBLE' ELSE CASE WHEN PINOTIERS LIKE '%FH%' THEN 'PLAST' ELSE 'MEUBLE' END END END END END AS ETAB
                           FROM        (SELECT     R2.R2_ID, R2.CE1, R2.CE3, R2.CE5, R2.DOS AS Expr1, R2.ETB, R2.G3CE1, R2.EFF, R2.TRANSAC, R2.TIERS, R2.ETAT, R2.ECHDT, R2.EMIDT, R2.EFFDT, R2.MT, LIENFACTURE.PREFFANO, LIENFACTURE.FANO, FACTURE.FADT, 
                                                                FACTURE.MT AS [MT FC], CLI.NOM, CLI.REPR_0001, VRP.NOM AS NOMREP, CLI.ADRCPL1, CLI.ADRCPL2, CLI.RUE, CLI.LOC, CLI.VIL, CASE dbo.CLI.FEU WHEN 3 THEN 'Bloqué' WHEN 2 THEN 'A Surveiller' ELSE '' END AS Controle, 
                                                                C8.PINOTIERS
                                              FROM        R2C8 LEFT OUTER JOIN
                                                                C8 ON R2C8.DOS = C8.DOS AND R2C8.ECRNO = C8.ECRNO AND R2C8.ECRLG = C8.ECRLG RIGHT OUTER JOIN
                                                                R2 ON R2C8.EFF = R2.EFF AND R2C8.DOS = R2.DOS LEFT OUTER JOIN
                                                                VRP RIGHT OUTER JOIN
                                                                CLI ON VRP.TIERS = CLI.REPR_0001 AND VRP.DOS = CLI.DOS ON R2.DOS = CLI.DOS AND R2.TIERS = CLI.TIERS LEFT OUTER JOIN
                                                                RA AS ETAT ON ETAT.ETAT = R2.ETAT LEFT OUTER JOIN
                                                                R3 AS LIENFACTURE ON LIENFACTURE.R3_ID =
                                                                    (SELECT     TOP (1) R3_ID
                                                                     FROM        R3 AS R3FANO
                                                                     WHERE     (CE1 = '3') AND (R2.DOS = DOS) AND (G3CE1 = R2.G3CE1) AND (EFF = R2.EFF) AND (TIERS IS NOT NULL) AND (FANO IS NOT NULL)
                                                                     ORDER BY PREFFANO, FANO) LEFT OUTER JOIN
                                                                R1 AS FACTURE ON FACTURE.DOS = LIENFACTURE.DOS AND FACTURE.G3CE1 = LIENFACTURE.G3CE1 AND FACTURE.TIERS = LIENFACTURE.TIERS AND FACTURE.PREFPIECE = LIENFACTURE.PREFFANO AND 
                                                                FACTURE.PIECE = LIENFACTURE.FANO
                                              WHERE     (R2.DOS = ".$req->DOS.") AND (R2.CE1 = '2') AND (R2.CE5 = '1') AND (R2.CE3 = '1' OR
                                                                R2.CE3 = '2' OR
                                                                R2.CE3 = '3') AND (R2.G3CE1 = 3) AND (R2.ETAT LIKE '%10')) AS derivedtbl_1
                           UNION ALL
                           SELECT     ENT.REPR_0001, VRP_1.NOM, ENT.ETB, ENT.TIERS, CLI_1.NOM AS CLI, ENT.PIDT, ENT.PREFPINO, CONVERT(varchar, ENT.PINO) AS FANO, CASE WHEN dbo.ENT.OP LIKE 'D%' THEN - dbo.ENT.TTCMT ELSE dbo.ENT.TTCMT END AS TTCMT, 0 AS PAYE, 
                                             CASE WHEN dbo.ENT.OP LIKE 'D%' THEN - dbo.ENT.TTCMT ELSE dbo.ENT.TTCMT END AS RESTE, CASE CLI_1.FEU WHEN 3 THEN 'Bloqué' WHEN 2 THEN 'A Surveiller' ELSE '' END AS Controle, 
                                             CASE WHEN dbo.ENT.ETB = 2 THEN 'PLAST' ELSE 'MEUBLE' END AS ETAB
                           FROM        ENT LEFT OUTER JOIN
                                             CLI AS CLI_1 ON ENT.TIERS = CLI_1.TIERS AND ENT.DOS = CLI_1.DOS LEFT OUTER JOIN
                                             VRP AS VRP_1 ON ENT.REPR_0001 = VRP_1.TIERS AND ENT.DOS = VRP_1.DOS
                           WHERE     (ENT.PICOD = 4) AND (ENT.TICOD = 'C') AND (ENT.DOS = '".$req->DOS."') AND (ENT.CE2 = '1')) AS derivedtbl_2 LEFT OUTER JOIN
                              (SELECT     derivedtbl_1_1.TIERS, CLI_2.NOM, SUM(derivedtbl_1_1.MTACOMPTE) AS MTACOMPTE, CLI_2.REPR_0001, VRP_2.NOM AS NOMREP, CASE CLI_2.FEU WHEN 3 THEN 'Bloqué' WHEN 2 THEN 'A Surveiller' ELSE '' END AS Controle, 
                                                 CASE WHEN derivedtbl_1_1.USIM_ETB = 2 THEN 'PLAST' ELSE 'MEUBLE' END AS ETAB
                               FROM        VRP AS VRP_2 RIGHT OUTER JOIN
                                                 CLI AS CLI_2 ON VRP_2.TIERS = CLI_2.REPR_0001 AND VRP_2.DOS = CLI_2.DOS RIGHT OUTER JOIN
                                                     (SELECT     R2_1.R2_ID, R2_1.CE1, R2_1.CE3, R2_1.CE5, R2_1.DOS, R2_1.ETB, R2_1.G3CE1, R2_1.EFF, R2_1.TRANSAC, R2_1.TIERS, R2_1.ETAT, R2_1.ECHDT, R2_1.EMIDT, R2_1.EFFDT, - R2_1.MT AS MTACOMPTE, R2_1.USIM_ETB
                                                      FROM        R2 AS R2_1 LEFT OUTER JOIN
                                                                        RA AS ETAT ON ETAT.ETAT = R2_1.ETAT
                                                      WHERE     (R2_1.DOS = ".$req->DOS.") AND (R2_1.CE1 = '2') AND (R2_1.CE5 = '1') AND (R2_1.CE3 = '1' OR
                                                                        R2_1.CE3 = '2' OR
                                                                        R2_1.CE3 = '3') AND (R2_1.G3CE1 = 3) AND (R2_1.ETAT = 'WAR') AND (R2_1.EFFDT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."')) AS derivedtbl_1_1 ON CLI_2.TIERS = derivedtbl_1_1.TIERS AND CLI_2.DOS = derivedtbl_1_1.DOS
                               GROUP BY derivedtbl_1_1.TIERS, CLI_2.NOM, CLI_2.REPR_0001, VRP_2.NOM, CLI_2.FEU, derivedtbl_1_1.USIM_ETB) AS derivedtbl_3 ON derivedtbl_2.TIERS = derivedtbl_3.TIERS AND derivedtbl_2.ETAB = derivedtbl_3.ETAB
        WHERE     (derivedtbl_2.FADT BETWEEN '".$req->date_debut."' AND '".$req->date_fin."')
        GROUP BY derivedtbl_2.NOMREP, derivedtbl_2.ETB, derivedtbl_2.TIERS, derivedtbl_2.NOM, ISNULL(derivedtbl_3.MTACOMPTE, 0)
        HAVING     (derivedtbl_2.TIERS IN ('".$req->client."'))");
    }
}
