class M_Stock {
  String REF;
  String DES;
  double QTE;
  int    NB;




  M_Stock(this.REF, this.DES, this.QTE,this.NB);

  factory M_Stock.fromJson(Map<String, dynamic> json) {
    return M_Stock(
      json['REF'].toString().trimRight(),
      json['DES'].toString().trimRight(),
      json['QTE'],
      json['NB'],


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'REF'    : REF,
      'DES'    : DES,
      'QTE'    : QTE,
      'NB'     : NB,


    };
  }
}
