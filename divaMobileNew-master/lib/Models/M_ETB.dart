class M_ETB {
  String ETB;
  String NOM;



  M_ETB(this.ETB, this.NOM);

  factory M_ETB.fromJson(Map<String, dynamic> json) {
    return M_ETB(
      json['ETB'].toString(),
      json['NOM'].toString().trimRight(),


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ETB'  : ETB,
      'NOM'    : NOM,


    };
  }
}
