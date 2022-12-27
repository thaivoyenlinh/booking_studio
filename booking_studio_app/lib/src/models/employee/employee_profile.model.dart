class EmployeeProfileModel{
  final int id;
  final int badgeId;
  final String fullname;
  final String phoneNumber;
  final String email;
  final String image;
  final String rating;

  EmployeeProfileModel( {
    required this.id, 
    required this.badgeId,
    required this.fullname, 
    required this.phoneNumber, 
    required this.email, 
    required this.image, 
    required this.rating
  });

  factory EmployeeProfileModel.fromJson(Map<String, dynamic> json) {
    return EmployeeProfileModel(
      id: json['id'] == null ? null : json['id'],
      badgeId: json['badgeId'] == null ? null : json['badgeId'],
      fullname: json['name'] == null ? null : json['name'],
      phoneNumber: json['phoneNumber'] == null ? null : json['phoneNumber'],
      email: json['email'] == null ? null : json['email'],
      image: json['image'] == null ? null : json['image'],
      rating: json['rating'] == null ? 0 : json['rating']
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "badgeId": badgeId,
        "fullname": fullname,
        "phoneNumber": phoneNumber,
        "email": email,
        "image": image,
        "rating": rating
      };
}