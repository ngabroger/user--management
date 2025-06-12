class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? avatar;
  final String? avatarUrl;
  final String? emailVerifiedAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.avatarUrl,
    this.emailVerifiedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      avatarUrl: json['avatar_url'],
      emailVerifiedAt: json['email_verified_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'avatar_url': avatarUrl,
      'email_verified_at': emailVerifiedAt,
    };
  }
}
