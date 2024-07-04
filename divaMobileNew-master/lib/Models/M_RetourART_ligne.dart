class M_RetourART_ligne {

  String TIERS;
  String NUM_PIECE;
  String DT;
  String NOM;
  String NUM_FACT;
  String QTE1;
  String TICOD;
  String OP;
  String BLSLG;
  String FADT;
  String UMOTIF_RETOUR;
  String RTRQTE;
  String U_DESC;


  M_RetourART_ligne(
      this.TIERS,
      this.NUM_PIECE,
      this.DT,
      this.NOM,
      this.NUM_FACT,
      this.QTE1,
      this.TICOD,
      this.OP,
      this.BLSLG,
      this.FADT,
      this.UMOTIF_RETOUR,
      this.RTRQTE,
      this.U_DESC,
      );

  factory M_RetourART_ligne.fromJson(Map<String, dynamic> json) {
    return M_RetourART_ligne(
      json['TIERS'].toString().trimRight(),
      json['NUM_PIECE'].toString().trimRight(),
      json['DT'].toString().trimRight(),
      json['NOM'].toString().trimRight(),
      json['NUM_FACT'].toString().trimRight(),
      json['QTE'].toString().trimRight(),
      json['TICOD'].toString().trimRight(),
      json['OP'].toString().trimRight(),
      json['BLSLG'].toString().trimRight(),
      json['FADT'].toString().trimRight(),
      json['UMOTIF_RETOUR'].toString().trimRight(),
      json['RTRQTE'].toString().trimRight(),
      json['U_DESC'].toString().trimRight(),


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TIERS'        : TIERS,
      'NUM_PIECE'    : NUM_PIECE,
      'DT'           : DT,
      'NOM'          : NOM,
      'NUM_FACT'     : NUM_FACT,
      'QTE'         : QTE1,
      'TICOD'        : TICOD,
      'OP'           : OP,
      'BLSLG'        : BLSLG,
      'FADT'         : FADT,
      'UMOTIF_RETOUR': UMOTIF_RETOUR,
      'RTRQTE'       : RTRQTE,
      'U_DESC'       : U_DESC,

    };
  }
}
