class M_Representant {
  String TIERS;
  String NOM;



  M_Representant(this.TIERS, this.NOM);

  factory M_Representant.fromJson(Map<String, dynamic> json) {
    return M_Representant(
      json['TIERS'].toString().trimRight(),
      json['NOM'].toString().trimRight(),


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TIERS'  : TIERS,
      'NOM'    : NOM,


    };
  }
}
