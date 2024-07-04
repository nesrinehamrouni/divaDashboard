class M_Payeur {
  String TIERSR3;
  String NOM;



  M_Payeur(this.TIERSR3, this.NOM);

  factory M_Payeur.fromJson(Map<String, dynamic> json) {
    return M_Payeur(
      json['TIERSR3'].toString().trimRight(),
      json['NOM'].toString().trimRight(),


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TIERS'  : TIERSR3,
      'NOM'    : NOM,


    };
  }
}
