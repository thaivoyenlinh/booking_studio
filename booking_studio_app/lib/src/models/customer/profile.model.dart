class ProfileModel{
  final int id;
  final String? fullname;
  final String? address;
  final String? phoneNumber;
  final String email;
  final String? image;

  ProfileModel({
    required this.id, 
    this.fullname, 
    this.address, 
    this.phoneNumber, 
    required this.email, 
    this.image, 
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      fullname: json['fullName'] == null ? null : json['fullName'] ,
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      image: json['image']
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "address": address,
        "phoneNumber": phoneNumber,
        "email": email,
        "image": image
      };
}