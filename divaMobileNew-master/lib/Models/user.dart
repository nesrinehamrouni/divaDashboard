class User {
  int? id;
  String? nom;
  String? prenom;
  String? image;
  String? email;
  String? token;

  User({
    this.id,
    this.nom,
    this.prenom,
    this.image,
    this.email,
    this.token
  });

  // function to convert json data to user model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      image: json['image'],
      email: json['email'],
      token: json['token']
    );
  }
}