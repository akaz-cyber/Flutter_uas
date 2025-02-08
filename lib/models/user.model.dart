class UserModel {
  final String? username;
  final String? email;
  final String? profileImage;
  final String? id;

  UserModel({
    this.username,
    this.email,
    this.profileImage,
    this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      profileImage: json['profile_image'],
      id: json['id'],
    );
  }
}
