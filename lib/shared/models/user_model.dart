/// User model representing an app user or creator.
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    this.handle,
    this.role,
    required this.avatarUrl,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final String? handle;
  final String? role;
  final String avatarUrl;
  final bool isOnline;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      handle: json['handle'] as String?,
      role: json['role'] as String?,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'handle': handle,
      'role': role,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? handle,
    String? role,
    String? avatarUrl,
    bool? isOnline,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
