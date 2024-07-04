class M_Ligne_Piece {
  String REF;
  String DES;
  String CDNO;
  String PREFCDNO;
  String CDDT;
  String CDLG;
  String CDQTE;
  String MONT;
  String OP;
  String DEPO;
  String TACOD;
  String VENUN;
  String REFUN;



  M_Ligne_Piece(this.REF, this.DES, this.CDNO, this.PREFCDNO, this.CDDT, this.CDLG, this.CDQTE, this.MONT, this.OP,
  this.DEPO, this.TACOD, this.VENUN, this.REFUN,);

  factory M_Ligne_Piece.fromJson(Map<String, dynamic> json) {
    return M_Ligne_Piece(
      json['REF'].toString().trimRight(),
      json['DES'].toString().trimRight(),
      json['CDNO'].toString().trimRight(),
      json['PREFCDNO'].toString().trimRight(),
      json['CDDT'].toString().trimRight(),
      json['CDLG'].toString().trimRight(),
      json['CDQTE'].toString().trimRight(),
      json['MONT'].toString().trimRight(),
      json['OP'].toString().trimRight(),
      json['DEPO'].toString().trimRight(),
      json['TACOD'].toString().trimRight(),
      json['VENUN'].toString().trimRight(),
      json['REFUN'].toString().trimRight(),


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'REF'      : REF,
      'DES'      : DES,
      'CDNO'     : CDNO,
      'PREFCDNO' : PREFCDNO,
      'CDDT'     : CDDT,
      'CDLG'     : CDLG,
      'CDQTE'    : CDQTE,
      'MONT'     : MONT,
      'OP'       : OP,
      'DEPO'     : DEPO,
      'TACOD'    : TACOD,
      'VENUN'    : VENUN,
      'REFUN'    : REFUN,



    };
  }
}
