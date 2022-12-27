class AuthModel {
  final String id;
  final String username;
  final String email;
  final String role;
  final String token;
  AuthModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.token
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'] as String, 
      username: json['username'] as String, 
      email: json['email'] as String, 
      role: json['role'] as String, 
      token: json['token'] as String );
  }
}