class M_ChiffreAffaire {
  String? TIERS;
  String? NOM;
  String? MONTT;
  String? TTC_SUM;
  String? N_FACT;
  String? PIDT;
  String? CA_Brut;
  String? CAB_FOD;
  String? MT_Rem;
  String? T_Rem;
  String? NET_FOD;
  String? CA_TTC;
  String? SREM_0001;
  String? TVAART;
  String? SFAQTE;
  String? NUM_PIECE;
  String? FADT;
  String? MONT;



  M_ChiffreAffaire(this.TIERS, this.NOM, this.MONTT, this.TTC_SUM);

  M_ChiffreAffaire.Detail(this.TIERS, this.NOM, this.N_FACT, this.PIDT, this.CA_Brut, this.CAB_FOD, this.MT_Rem,
  this.NET_FOD, this.CA_TTC, this.SREM_0001, this.TVAART, this.SFAQTE, this.TTC_SUM,this.T_Rem );

  M_ChiffreAffaire.DetailSH(this.TIERS, this.NOM, this.NUM_PIECE, this.FADT, this.MONT );

  factory M_ChiffreAffaire.fromJson(Map<String, dynamic> json) {
    return M_ChiffreAffaire(
      json['TIERS'].toString(),
      json['NOM'].toString(),
      json['MONTT'].toString(),
      json['TTC_SUM'].toString(),

    );
  }


  Map<String, dynamic> toJson() {
    return {
      'TIERS'  : TIERS,
      'NOM'    : NOM,
      'MONTT'  : MONTT,
      'TTC_SUM': TTC_SUM,

    };
  }
}
