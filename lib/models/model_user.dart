import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? address;
  final String? avatar;

  const UserModel({this.id, this.name, this.email, this.address, this.avatar});

  UserModel copyWith(
      {String? id,
      String? name,
      String? email,
      String? address,
      String? avatar}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'avatar': avatar,
    };
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      avatar: json['avatar'] as String?,
    );
  }

  static UserModel fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] as String?,
      email: data['email'] as String?,
      address: data['address'] as String?,
      avatar: data['avatar'] as String?,
    );
  }

  @override
  String toString() {
    return '''UserModel(
      id: $id,
      name: $name,
      email: $email,
      address: $address,
      avatar: $avatar
    )''';
  }

  @override
  bool operator ==(Object other) {
    return other is UserModel &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.address == address &&
        other.avatar == avatar;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, name, email, address, avatar);
  }
}
