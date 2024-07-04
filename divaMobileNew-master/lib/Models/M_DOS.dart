class M_DOS {
  String DOS;
  String NOM;



  M_DOS(this.DOS, this.NOM);

  factory M_DOS.fromJson(Map<String, dynamic> json) {
    return M_DOS(
      json['DOS'].toString(),
      json['NOM'].toString().trimRight(),


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DOS'  : DOS,
      'NOM'    : NOM,


    };
  }
}
