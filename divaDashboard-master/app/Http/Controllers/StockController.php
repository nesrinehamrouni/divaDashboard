<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class StockController extends Controller
{

    public function VerifStock($Article,$Depot){

        $nbline = 0; 
        foreach ($Article as $key => $value) { 
                 
            if($value->LGTYP != 2){
                $Qte=0; 
                $MVTL=DB::table('MVTL')->select(
                    'REF' , 'QTE', 'STQTE', 'REFQTE', 'OP', 'DEPO')
                ->where('DOS',$value->DOS)
                ->where('DEPO',$Depot) 
                ->where('REF',$value->REF)
                ->get();                 
                foreach ($MVTL as $key => $val) {
                    $Qte= $Qte+$val->STQTE; 
                               
                    if($val->OP=="999"){
                        $Qte=$Qte-$val->REFQTE;
                    }                    
                } 
                $value->QTE= $Qte;
                $nbline = $nbline+1;
                $value->NB = $nbline;
                        
            }
            else{
                $nb_kit=0;
                $DAR=DB::table('DAR')->select('REFCO', 'DAR_ID', 'QTE')
                    ->where('DOS',$value->DOS) 
                    ->where('REF',$value->REF)
                    ->get(); 
                foreach ($DAR as $keys => $DarValue) {  
                    $Qte=0;      
                        if($DarValue){
                            $MVTL=DB::table('MVTL')->select(
                                'REF' , 'QTE', 'STQTE', 'REFQTE', 'OP', 'DEPO' )
                            ->where('DOS',$value->DOS)
                            ->where('DEPO',$Depot) 
                            ->where('REF',$DarValue->REFCO)
                            ->get();             
                            foreach ($MVTL as $key => $val) {
                                $Qte= $Qte+$val->STQTE;
                                if($val->OP=="999"){
                                    $Qte=$Qte-$val->REFQTE;
                                }                    
                            }  
                            if($keys=0){
                                $nb_kit= $Qte/$DarValue->QTE;
                            }          
                            if($Qte/$DarValue->QTE < $nb_kit){
                                $nb_kit= $Qte/$DarValue->QTE;
                            }
                        }          
                        }  
                    $value->QTE= $nb_kit;
                    $nbline = $nbline+1;
                    $value->NB = $nbline;
            }
        }
        return $Article; 
    }


   

function get_stock(request $req){

    $USIM_TYPFAM = null ;
    $REFART = null ;
    
    if($req->USIM_TYPFAM != "" )
        {
            $USIM_TYPFAM ="AND ART.USIM_TYPFAM LIKE ".$req->USIM_TYPFAM."";
        }

    if($req->REFART != "" )
        {
            $REFART ="AND ART.REF LIKE ".$req->REFART."";
        }

    $Article =DB::select("SELECT   REF, LGTYP, DES, DOS FROM    ART where DOS = $req->DOS ".$USIM_TYPFAM." ".$REFART."
    ORDER BY REF
    OFFSET $req->NB ROWS 
    FETCH FIRST 10 ROWS ONLY");


$newART =$this->VerifStock($Article,$req->Depot);
// Trier la liste des articles
// usort($newART, function($article1, $article2) {
//     return $article2->QTE - $article1->QTE;
// });

    return  $newART;

    
    

    
    #return $this->VerifStock($Article);

  
}

function get_total(){
    return DB::select("SELECT   count(REF) as total FROM    ART ");
}

function get_familleART(){
    return DB::select("SELECT TYPE_FAM_ID, DOS, CODE_TYP, DES FROM TYPE_FAM ");
}
function get_REFART(request $req){
    return DB::select("SELECT  REF  FROM ART WHERE DOS = $req->DOS ");
}

}
