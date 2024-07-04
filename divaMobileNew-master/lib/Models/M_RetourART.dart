class M_RetourART {
  String REF;
  String DES;
  String QTE;




  M_RetourART(this.REF, this.DES, this.QTE);

  factory M_RetourART.fromJson(Map<String, dynamic> json) {
    return M_RetourART(
      json['REF'].toString().trimRight(),
      json['DES'].toString().trimRight(),
      double.parse(json['QTE'].toString()).toStringAsFixed(0),


    );
  }


  Map<String, dynamic> toJson() {
    return {
      'REF'    : REF,
      'DES'    : DES,
      'QTE'    : QTE,


    };
  }
}
