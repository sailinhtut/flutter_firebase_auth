class User {
  String? uid;
  String? name;
  String? email;
  String? image;
  String? phone;

  User({
    this.uid,
    required this.name,
    required this.email,
    required this.image,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      image: json["image"],
      phone: json["phone"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "image": image,
      "phone": phone,
    };
  }
}
