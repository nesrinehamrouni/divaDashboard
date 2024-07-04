class M_FA {
  String REPR_0001;
  String NOMREP;
  String ETB;
  String TIERS;
  String NOM;
  String FADT;
  String NUM_FC;
  String MT;
  String PAYE;
  String RESTE;
  String Controle;
  String ETAB;
  String ACOMPTE;






  M_FA(this.REPR_0001, this.NOMREP, this.ETB, this.TIERS, this.NOM, this.FADT, this.NUM_FC, this.MT, this.PAYE,
  this.RESTE, this.Controle, this.ETAB, this.ACOMPTE );

  factory M_FA.fromJson(Map<String, dynamic> json) {
    return M_FA(
      json['REPR_0001'].toString().trimRight(),
      json['NOMREP'].toString().trimRight(),
      json['ETB'].toString().trimRight(),
      json['TIERS'].toString().trimRight(),
      json['NOM'].toString().trimRight(),
      json['FADT'].toString().trimRight(),
      json['NUM_FC'].toString().trimRight().trimLeft(),
      json['MT FC'].toString().trimRight(),
      double.parse(json['PAYE'].toString()).toStringAsFixed(3),
      json['RESTE'].toString().trimRight(),
      json['Controle'].toString().trimRight(),
      json['ETAB'].toString().trimRight(),
      json['ACOMPTE'].toString().trimRight(),




    );
  }

  Map<String, dynamic> toJson() {
    return {
      'REPR_0001'    : REPR_0001,
      'NOMREP'       : NOMREP,
      'ETB'          : ETB,
      'TIERS'        : TIERS,
      'NOM'          : NOM,
      'FADT'         : FADT,
      'NUM_FC'       : NUM_FC,
      'MT'           : MT,
      'PAYE'         : PAYE,
      'RESTE'        : RESTE,
      'Controle'     : Controle,
      'ETAB'         : ETAB,
      'ACOMPTE'      : ACOMPTE,



    };
  }
}
