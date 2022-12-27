class UserModel {
  final int id;
  final int badgeId;
  final String name;
  final String email;
  final String image;
  UserModel({
    required this.id,
    required this.badgeId,
    required this.name,
    required this.email,
    required this.image
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'], 
      badgeId: json['badgeId'], 
      name: json['name'], 
      email: json['email'], 
      image: json['image']);
  }
}

