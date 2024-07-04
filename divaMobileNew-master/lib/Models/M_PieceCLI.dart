class M_PieceCLI {
  String ENT_ID;
  String CE4;
  String DOS;
  String TICOD;
  String PICOD;
  String TIERS;
  String PREFPINO;
  String PINO;
  String PIDT;
  String ETB;
  String STATUS;
  String DEV;
  String OP;
  String REPR_0001;
  String DEPO;
  String PIREF;
  String PINOTIERS;
  String REMCOD;
  String TPFT;
  String HTMT;
  String TTCMT;
  String HTPDTMT;
  String PIEDNO_0001;
  String PIRELCOD;
  String RELCOD;
  String TRCOD;
  String REM_0001;
  String CATPICOD;
  String NOM;



  M_PieceCLI(this.ENT_ID, this.CE4, this.DOS, this.TICOD, this.PICOD, this.TIERS, this.PREFPINO, this.PINO, this.PIDT, this.ETB, this.STATUS,
  this.DEV, this.OP, this.REPR_0001, this.DEPO, this.PIREF, this.PINOTIERS, this.REMCOD, this.TPFT, this.HTMT, this.TTCMT, this.HTPDTMT,
  this.PIEDNO_0001, this.PIRELCOD, this.RELCOD, this.TRCOD, this.REM_0001, this.CATPICOD,this.NOM);

  factory M_PieceCLI.fromJson(Map<String, dynamic> json) {
    return M_PieceCLI(
      json['ENT_ID'].toString().trimRight(),
      json['CE4'].toString().trimRight()=='1'?"actif":json['CE4'].toString().trimRight()=='8'? "périmer":"autre",
      json['DOS'].toString().trimRight(),
      json['TICOD'].toString().trimRight(),
      json['PICOD'].toString().trimRight()=='1'? "Devis":json['PICOD'].toString().trimRight()=='2'?"Commande":json['PICOD'].toString().trimRight()=='3'?"Bon de livraison":"Facture",
      json['TIERS'].toString().trimRight(),
      json['PREFPINO'].toString().trimRight(),
      json['PINO'].toString().trimRight(),
      json['PIDT'].toString().trimRight(),
      json['ETB'].toString().trimRight(),
        json['TICOD'].toString().trimRight()=='C'
            ?json['PICOD'].toString().trimRight()=='1'
            ?json['STATUS'].toString().trimRight()=='1'? "En demande":json['STATUS'].toString().trimRight()=='2'? "ok":"En cours"
            :json['PICOD'].toString().trimRight()=='2'
            ?json['STATUS'].toString().trimRight()=='1'? "A préparer":json['STATUS'].toString().trimRight()=='2'? "Préparée ou pas de préparation":"En cours de préparation"
            : json['STATUS'].toString().trimRight()=='1'? "En attente":"Ok"
          /***** partie fou ***********/
        :json['PICOD'].toString().trimRight()=='1'?""
            :json['PICOD'].toString().trimRight()=='2'?json['STATUS'].toString().trimRight()=='1'? "AR en attente":"AR reçu ou non demandé"
       :json['STATUS'].toString().trimRight()=='1'? "En attente":"OK",
      json['DEV'].toString().trimRight(),
      json['OP'].toString().trimRight(),
      json['REPR_0001'].toString().trimRight(),
      json['DEPO'].toString().trimRight(),
      json['PIREF'].toString().trimRight(),
      json['PINOTIERS'].toString().trimRight(),
      json['REMCOD'].toString().trimRight(),
      json['TPFT'].toString().trimRight(),
      json['HTMT'].toString().trimRight(),
      json['TTCMT'].toString().trimRight(),
      json['HTPDTMT'].toString().trimRight(),
      json['PIEDNO_0001'].toString().trimRight(),
      json['PIRELCOD'].toString().trimRight(),
      json['RELCOD'].toString().trimRight(),
      json['TRCOD'].toString().trimRight(),
      json['REM_0001'].toString().trimRight(),
      json['CATPICOD'].toString().trimRight(),
      json['NOM'].toString().trimRight(),


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ENT_ID'      : ENT_ID,
      'CE4'         : CE4,
      'DOS'         : DOS,
      'TICOD'       : TICOD,
      'PICOD'       : PICOD,
      'TIERS'       : TIERS,
      'PREFPINO'    : PREFPINO,
      'PINO'        : PINO,
      'PIDT'        : PIDT,
      'ETB'         : ETB,
      'STATUS'      : STATUS,
      'DEV'         : DEV,
      'OP'          : OP,
      'REPR_0001'   : REPR_0001,
      'DEPO'        : DEPO,
      'PIREF'       : PIREF,
      'PINOTIERS'   : PINOTIERS,
      'REMCOD'      : REMCOD,
      'TPFT'        : TPFT,
      'HTMT'        : HTMT,
      'TTCMT'       : TTCMT,
      'HTPDTMT'        : HTPDTMT,
      'PIEDNO_0001'    : PIEDNO_0001,
      'PIRELCOD'       : PIRELCOD,
      'RELCOD'         : RELCOD,
      'TRCOD'          : TRCOD,
      'REM_0001'       : REM_0001,
      'CATPICOD'       : CATPICOD,
      'NOM'            : NOM,



    };
  }
}
